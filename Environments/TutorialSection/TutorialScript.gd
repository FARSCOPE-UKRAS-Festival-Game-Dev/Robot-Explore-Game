extends Node

var INTRO_SCENE = preload("res://Utilities/IntroSequence.tscn")
var off_texture = preload("res://Assets/Images/animated_static.tres")
const DIALOG_FILE  = "res://Assets/Dialog/DefaultDialog.json"

var robot_control_panel
var cam_panel
var lidar_panel
var whisker_panel
var skip

var sample_attempts = 0
const robot_action = preload("res://Robot/Robot_with_sensors.gd").robot_action
onready var calibration_body = get_node("../../TemperatureCalibrationBody")

func _ready():
	Globals.load_dialog_from_file(DIALOG_FILE)
	get_node("/root/TutorialMission").connect("finished_loading",self,"start_tutorial")
	skip = Globals.skip_tutorial

func init_heatmap():
	Globals.robot.get_node("Robot/TempLeft").calibrate_from_body(calibration_body)
	Globals.robot.get_node("Robot/TempRight").calibrate_from_body(calibration_body)

func start_tutorial():
	
	init_heatmap()
	robot_control_panel = Globals.robot.get_node("ControlPanel")
	cam_panel = robot_control_panel.get_node("HUD/CameraPanel")
	lidar_panel = robot_control_panel.get_node("HUD/LidarPanel")
	whisker_panel = robot_control_panel.get_node("HUD/WhiskerPanel")

	
	if not skip:
		Globals.joystick.set_visible(false)
		Globals.control_panel_ui.set_enable_fade_overlay(true)

		
		for panel in [cam_panel,lidar_panel,whisker_panel]:
			panel.enabled = false
			panel._render_texture_to_hud(off_texture)
		yield(get_tree().create_timer(0.1), "timeout")
		Globals.control_panel_ui.fade_in()
		
		yield(get_tree().create_timer(1.0), "timeout")
		Globals.queue_dialog("tutorial_camera_on_start1")
		yield(Globals,"all_dialog_finished")
		get_node("../TurnOnCamera").enabled = true
	else:
		Globals.robot.global_transform = get_node("/root/TutorialMission/RobotStartLocationDebug").global_transform 
		get_node("../LeaveLevel").enabled = true
	Globals.joystick.set_visible(true)
	print("intro complete")

func _on_TurnOnCamera_on_enable():
	robot_control_panel.isolate_panel("CameraPanel")
	cam_panel.connect("gui_input",self,"camera_turned_on")

func camera_turned_on(event):
	if event.is_pressed():#and not get_node("../TurnOnCamera").complete : 
		cam_panel.disconnect("gui_input",self,"camera_turned_on")
		get_node("../TurnOnCamera").complete_objective()
		get_node("../Audio/software_on_camera_audio").play()
		cam_panel.enabled = true
		robot_control_panel.remove_isolate_panel()
		yield(Globals,"all_dialog_finished")
		

func _on_TurnOnWhiskers_on_enable():

	robot_control_panel.isolate_panel("WhiskerPanel")
	whisker_panel.connect("gui_input",self,"whiskers_turned_on")
	
func whiskers_turned_on(event):

	if event.is_pressed():
		get_node("../TurnOnWhiskers").complete_objective()
		whisker_panel.enabled = true
		get_node("../Audio/software_on_whisker_audio").play()
		whisker_panel.disconnect("gui_input",self,"whiskers_turned_on")
		
		robot_control_panel.remove_isolate_panel()

func _on_CollectSample_on_enable():
	if Globals.robot != null:
		Globals.robot.connect("action_failed",self,"trigger_sample_hint")
		sample_attempts = 0
	
func _on_CollectSample_on_disable():
	if Globals.robot != null:
		Globals.robot.disconnect("action_failed",self,"trigger_sample_hint")

func trigger_sample_hint(action):
	if action == robot_action.COLLECT_SAMPLE:
		sample_attempts+=1
		if sample_attempts > 5:
			Globals.queue_dialog("tutorial_sample_fail")
			sample_attempts = 0

func _on_TurnOnLidar_on_enable():
	robot_control_panel.isolate_panel("LidarPanel")
	lidar_panel.connect("gui_input",self,"lidar_turned_on")
	
func lidar_turned_on(event):
	if event.is_pressed():
		lidar_panel.enabled = true
		get_node("../Audio/software_on_lidar_audio").play()
		robot_control_panel.remove_isolate_panel()
		get_node("../TurnOnLidar").complete_objective()








var cave_gate_debounce = false

func _on_CollectSample_on_objective_complete(ObjectiveBase):
	get_node("../CaveGate").queue_free()
	get_node("../CaveGateTrigger").queue_free()
	
func _on_CaveGateTrigger_on_trigger():
	print("gate triggered!")
	if not cave_gate_debounce:
		cave_gate_debounce = true
		Globals.queue_dialog("tutorial_gate_leave_attempt")
	
		if not get_node("../GoToRock").complete:
			Globals.queue_dialog("tutorial_gate_doing_rock")
		elif not get_node("../UseWhiskers").complete:
			Globals.queue_dialog("tutorial_gate_doing_whiskers")
		elif not get_node("../CollectSample").complete:
			Globals.queue_dialog("tutorial_gate_doing_sample")
		yield(get_tree().create_timer(30),"timeout")
		cave_gate_debounce = false

var photo_attempts = 0
func _on_PhotoRobot_on_enable():
	print("on_photo_enable")
	Globals.robot.connect("action_failed",self,"photo_fail_hint")
	photo_attempts = 0
	
func _on_PhotoRobot_on_disable():
	if Globals.robot != null:
		Globals.robot.disconnect("action_failed",self,"photo_fail_hint")

func photo_fail_hint(action):
	if action == robot_action.TAKING_PICTURE:
		photo_attempts+=1
		if photo_attempts > 5:
			Globals.queue_dialog("tutorial_photo_robot_fail")
			photo_attempts = 0

func _on_LeaveLevel_on_enable():
	get_node("../LeaveLevelTrigger").enabled = true
	
func _on_LeaveLevelTrigger_on_trigger():
	Globals.control_panel_ui.fade_out()
	Globals.robot.immobilise = true
	
	Globals.queue_raw_dialog("Tutorial End", "*Static* ...He...o? ...lo!? Are you still there!?... Wh...")
	yield(Globals, "all_dialog_finished")
	
	var mission = get_parent()
	mission.complete_mission()
	yield(get_tree().create_timer(8),"timeout")
	
#	yield(get_tree().create_timer(5.0), "timeout")
	Globals.load_new_scene("res://Environments/MissionSection/finalMissionCave.tscn")
	





