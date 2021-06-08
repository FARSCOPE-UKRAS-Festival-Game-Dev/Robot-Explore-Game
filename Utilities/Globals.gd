extends Node


#### Options
var debug_mode = true
var show_triggers = false
var camera_trigger_debug = false
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
signal dialog_loaded
signal dialog_finished
signal all_dialog_finished
signal options_updated 

# Called when the node enters the scene tree for the first time.
func _ready():
	var default_dialog = "res://Assets/Dialog/dialog_JSON.json"
	load_dialog_from_file(default_dialog)
	emit_signal("dialog_loaded")
func dialog_finished(dialog_key):
	emit_signal("dialog_finished",dialog_key)
func all_dialog_finished():
	play_audio_radio_off()
	emit_signal("all_dialog_finished")
	
func on_options_updated():
	emit_signal("options_updated")
	
func load_dialog_from_file(file_path):
	var file = File.new()
	
	file.open(file_path, File.READ)
	var JSON_result = JSON.parse(file.get_as_text())
	assert(JSON_result.error == OK, "Error loading JSON check format!")
	dialog_JSON_data =  JSON_result.result


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
	if not dialog_JSON_data.has(dialog_key):
		print("ERROR - dialog key: \"%s\" not in JSON file" % dialog_key)
		dialog_key = "dialog_not_found"
	
	if len(dialog_popup.text_queue) == 0:
		play_audio_radio_on()
	
	var dialog_data = dialog_JSON_data[dialog_key]
	dialog_popup.queue_text(dialog_data["dialog"],dialog_key)
	
	
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

func play_audio_radio_on():
	dialog_popup.audio_radio_on.play()

func play_audio_radio_off():
	dialog_popup.audio_radio_off.play()
