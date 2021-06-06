extends Node

var off_texture = preload("res://Assets/Images/Static.png")


var robot_control_panel
var cam_panel
var lidar_panel
var whisker_panel

var linked_dialog = ["../EnterDarkCaveDialog","../DeadEndDialog","../NearEndOfCaveDialog"]
func _ready():
	get_node("/root/Mission1").connect("finished_loading",self,"start_tutorial")

func enabled_dialogs():
	for dialog in linked_dialog:
		dialog.enabled = true

func start_tutorial():

	Globals.control_panel_ui.get_node("FadeOverlay").show()
	Globals.joystick.hide()
	
	robot_control_panel = Globals.robot.get_node("ControlPanel")
	cam_panel = robot_control_panel.get_node("HUD/CameraPanel")
	lidar_panel = robot_control_panel.get_node("HUD/LidarPanel")
	whisker_panel = robot_control_panel.get_node("HUD/WhiskerPanel")
	for panel in [cam_panel,lidar_panel,whisker_panel]:
		panel.enabled = false
		panel._render_texture_to_hud(off_texture)
	
	
	Globals.queue_dialog("tutorial_start")
	yield(Globals,"all_dialog_finished")
	
	Globals.control_panel_ui.fade_in()
	
	yield(get_tree().create_timer(1.0), "timeout")
	Globals.queue_dialog("tutorial_camera_on_start1")
	yield(Globals,"all_dialog_finished")
	get_node("../TurnOnCamera").enabled = true
	print("intro complete")

func _on_TurnOnCamera_on_enable():
	robot_control_panel.isolate_panel("CameraPanel")
	cam_panel.connect("gui_input",self,"camera_turned_on")

func camera_turned_on(event):
	if event.is_pressed():#and not get_node("../TurnOnCamera").complete : 
		cam_panel.disconnect("gui_input",self,"camera_turned_on")
		get_node("../TurnOnCamera").complete_objective()
		cam_panel.enabled = true
		robot_control_panel.remove_isolate_panel()
		yield(Globals,"all_dialog_finished")
		

func _on_TurnOnWhiskers_on_enable():

	robot_control_panel.isolate_panel("WhiskerPanel")
	whisker_panel.connect("gui_input",self,"whiskers_turned_on")
	
func whiskers_turned_on(event):

	if event.is_pressed():
		whisker_panel.enabled = true
		whisker_panel.disconnect("gui_input",self,"whiskers_turned_on")
		get_node("../TurnOnWhiskers").complete_objective()
		robot_control_panel.remove_isolate_panel()

func _on_UseWhisker_on_enable():
	var interesting_rock_info = get_node("../InterestingRock/TactileInfo")
	interesting_rock_info.connect("sensed_by_whiskers",self,"use_whisker_complete",[],CONNECT_ONESHOT)

func use_whisker_complete():
	yield(whisker_panel,"reveal_animation_finished")
	get_node("../UseWhiskers").complete_objective()

func check_drill_distance():
	var distance =  Globals.robot.body.global_transform.origin.distance_to(get_node("../InterestingRock").global_transform.origin)
	print(distance)
	if distance <= 3:
		return true
	Globals.queue_dialog("tutorial_drill_too_far")
	return false
	

func _on_TurnOnLidar_on_enable():
	robot_control_panel.isolate_panel("LidarPanel")
	lidar_panel.connect("gui_input",self,"lidar_turned_on")
	
func lidar_turned_on(event):
	if event.is_pressed():
		lidar_panel.enabled = true
		robot_control_panel.remove_isolate_panel()
		get_node("../TurnOnLidar").complete_objective()

func _on_EnterCave_on_enable():
	get_node("../EnterDarkCaveDialog").enabled = true


