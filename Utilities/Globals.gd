extends Node

#### Constants
const MAIN_MENU_PATH = "res://MainMenu.tscn"
const LOADING_ANIMATION = preload("res://Utilities/Misc/LoadingAnimation.tscn")

#### Debug tools
var debug_mode = true
var show_triggers = false
var fast_hint = false
var camera_trigger_debug = false

var temp_debug = false
var trigger_debug = false
var follow_camera = false

##### Control Interface
var control_panel_ui_scene_pl = preload('res://Utilities/Control_Panel_UI.tscn')
var control_panel_loaded = false
var is_joystick_enabled = true

var control_panel_ui
var joystick
var book_overlay
var dialog_popup
var objective_popup
#####
var dialog_JSON_data

var robot = null

var displaying_dialog = false

#### Loading
var loader
var wait_frames
var time_max = 100
var current_scene



signal dialog_loaded
signal dialog_finished
signal all_dialog_finished
signal options_updated 

#### Sound
var audio_clips = {
	"camera_snap": preload("res://Assets/Audio/effects/camera_snap.wav"),
	"drill_success": preload("res://Assets/Audio/effects/drill_success.wav"),
	"drill_fail": preload("res://Assets/Audio/effects/drill_fail.wav"),
	"robot_arm": preload("res://Assets/Audio/effects/sample_arm_motion.wav"),
	"radio_on": preload("res://Assets/Audio/effects/radio_on.wav"),
	"radio_off": preload("res://Assets/Audio/effects/radio_end.wav"),
	"switch_on": preload("res://Assets/Audio/effects/switch_on.wav"),
	"switch_off": preload("res://Assets/Audio/effects/switch_off.wav"),
	"warning_sound": preload("res://Assets/Audio/effects/warning_sound.wav")
}

# The simple audio player scene
const SIMPLE_AUDIO_PLAYER_SCENE = preload("res://Utilities/AudioPlayer.tscn")

# A list to hold all of the created audio nodes
var created_audio = []

# ------------------------

# Called when the node enters the scene tree for the first time.
func _ready():
	var default_dialog = "res://Assets/Dialog/DefaultDialog.json"
	load_dialog_from_file(default_dialog)
	current_scene = get_tree().get_current_scene()

func _process(time):
	if loader == null:
		# no need to process anymore
		set_process(false)
		return

	# Wait for frames to let the "loading" animation show up.
	if wait_frames > 0:
		wait_frames -= 1
		return

	var t = OS.get_ticks_msec()
	# Use "time_max" to control for how long we block this thread.
	while OS.get_ticks_msec() < t + time_max:
		# Poll your loader.
		var err = loader.poll()

		if err == ERR_FILE_EOF: # Finished loading.
			var resource = loader.get_resource()
			loader = null
			set_new_scene(resource)
			break
		elif err == OK:
			update_progress()
		else: # Error during loading.
			show_error()
			loader = null
			break

func show_error():
	print('ERROR OCCURED ON LOADING')

func dialog_finished(dialog_key):
	
	emit_signal("dialog_finished",dialog_key)
func all_dialog_finished():
	play_audio_radio_off()
	displaying_dialog = false
	emit_signal("all_dialog_finished")
	
func on_options_updated():
	emit_signal("options_updated")
	
func load_dialog_from_file(file_path):
	var file = File.new()
	
	file.open(file_path, File.READ)
	var JSON_result = JSON.parse(file.get_as_text())
	assert(JSON_result.error == OK, "Error loading JSON check format!")
	dialog_JSON_data =  JSON_result.result
	emit_signal("dialog_loaded")
	
func goto_scene(path):
	#	Refer to https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html
	var loading_scene = LOADING_ANIMATION.instance()
	loading_scene.name = 'animation'
	add_child(loading_scene)
	
	loader = ResourceLoader.load_interactive(path)
	if loader == null:
		show_error()
		return
	set_process(true)
	
	current_scene.queue_free()
	get_node("animation").play("loading")
	
	wait_frames = 1
	
func update_progress():
	var progress = float(loader.get_stage()) / loader.get_stage_count()
	# Update your progress bar?
#	get_node("progress").set_progress(progress)

	# ...or update a progress animation?
	var length = get_node("animation").get_current_animation_length()

	# Call this on a paused animation. Use "true" as the second argument to
	# force the animation to update.
	get_node("animation").seek(progress * length, true)

func set_new_scene(scene_resource):
	current_scene = scene_resource.instance()
	get_node("/root").add_child(current_scene)
	
func load_new_scene(new_scene_path):
	# Delete all of the sounds
	for sound in created_audio:
		if (sound != null):
			sound.queue_free()
	created_audio.clear()
	
	goto_scene(new_scene_path)
#	get_tree().change_scene(new_scene_path)

func quit_to_main_menu():
	# Remove all missions
	for mission_node in get_tree().get_nodes_in_group("Missions"):
		mission_node.queue_free()
	
	# Remove control panel ui
	control_panel_ui.queue_free()
	
	# Remove the robot
	robot.queue_free()
		
	control_panel_loaded = false
	
	load_new_scene(MAIN_MENU_PATH)

func init_control_panel():
	if not control_panel_loaded:
		
		var root = get_tree().get_root()
		
		control_panel_ui = control_panel_ui_scene_pl.instance()
		root.add_child(control_panel_ui)
		
		joystick = control_panel_ui.get_node('MarginContainer/Joystick')
		if not OS.has_touchscreen_ui_hint() and joystick.visibility_mode == joystick.VisibilityMode.TOUCHSCREEN_ONLY:
			is_joystick_enabled = false
		
		book_overlay = control_panel_ui.get_node('BookOverlay')
		set_book_visible(false)
		
		dialog_popup = control_panel_ui.get_node('DialogPopup')
		dialog_popup.connect("dialog_finished",self,"dialog_finished")
		dialog_popup.connect("finished_dialog_queue",self,"all_dialog_finished")
		
		objective_popup = control_panel_ui.get_node("ObjectivePopup")
		
		for mission_node in get_tree().get_nodes_in_group("Missions"):
			mission_node.connect("mission_completed",self,"show_mission_complete_popup",[mission_node,])
			for objective in mission_node.objective_list:
				objective.connect("on_objective_complete",self,"show_objective_complete_popup")
				objective.connect("on_enable",self,"show_new_objective_complete_popup",[objective,])
			
		control_panel_loaded = true

func set_book_visible(value):
	book_overlay.visible = value
	joystick.enabled = !value
	 
func queue_dialog(dialog_key):
	displaying_dialog = true
	if not dialog_JSON_data.has(dialog_key):
		print("ERROR - dialog key: \"%s\" not in JSON file" % dialog_key)
		dialog_key = "dialog_not_found"
	
	if len(dialog_popup.text_queue) == 0:
		play_audio_radio_on()
	
	var dialog_data = dialog_JSON_data[dialog_key]
	dialog_popup.queue_text(dialog_data["dialog"],dialog_key)
	
	if book_overlay:
		book_overlay.add_journal_entry(dialog_data["dialog"])
	

	if dialog_data.has("next_dialog"):
		queue_dialog(dialog_data["next_dialog"])

func show_mission_complete_popup(mission):
	objective_popup.display_text("Mission Completed - " + mission.mission_name)

func show_objective_complete_popup(objective):
	objective_popup.display_text("Objective Complete - "+objective.display_text)

func show_new_objective_complete_popup(objective):
	objective_popup.display_text("New Objective - "+objective.display_text)
	robot.get_node("ControlPanel").mark_read_book_icon(false)

func play_sound(sound_name, volume_db=0.0, loop_sound=false, sound_position=null):
	# If we have a audio clip with with the name sound_name
	if audio_clips.has(sound_name):
		# Make a new simple audio player and set it's looping variable to the loop_sound
		var new_audio = SIMPLE_AUDIO_PLAYER_SCENE.instance()
		new_audio.should_loop = loop_sound
		
		# Add it as a child and add it to created_audio
		add_child(new_audio)
		created_audio.append(new_audio)
		
		# Send the newly created simple audio player the audio stream and sound position
		new_audio.set_volume_db(volume_db)
		new_audio.play_sound(audio_clips[sound_name], sound_position)
	
	# If we do not have an audio clip with the name sound_name, print a error message
	else:
		print ("ERROR: cannot play sound that does not exist in audio_clips!")

func play_audio_radio_on():
	dialog_popup.audio_radio_on.play()

func play_audio_radio_off():
	dialog_popup.audio_radio_off.play()
