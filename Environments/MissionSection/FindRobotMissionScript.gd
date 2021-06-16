extends Node
onready var calibration_body = get_node("../../TemperatureCalibrationBody")
var off_texture = preload("res://Assets/Images/animated_static.tres")

onready var steps_sound = get_node("../Audio/YetiSteps")
onready var roar_sound =  get_node("../Audio/YetiRoar")

func _ready():
	var skip = false

	if not skip:
		get_node("/root/MissionSection").connect("finished_loading",self,"start_mission")
	else:
		get_node("/root/MissionSection").connect("finished_loading",self,"init_heatmap")
		
func init_heatmap():
	Globals.robot.get_node("Robot/TempLeft").calibrate_from_body(calibration_body)
	Globals.robot.get_node("Robot/TempRight").calibrate_from_body(calibration_body)

func start_mission():
	init_heatmap()
	
	var disable_starting_dialog = true
	if not disable_starting_dialog:
		Globals.queue_dialog("mission_start_1")
		yield(Globals,"all_dialog_finished")
	yield(get_tree().create_timer(1.0),"timeout")
	get_node("../LocateRobot").enabled = true

func _on_LocateRobot_on_objective_complete(ObjectiveBase):

	Globals.queue_dialog("mission_find_robot_discover_robot")
	yield(Globals,"all_dialog_finished")
	yield(get_tree().create_timer(1.0),"timeout")
	
	steps_sound.connect("finished",self,"end_game")
	steps_sound.play()
	Globals.robot.viewing_camera.get_node("CameraShaker").start(10, 15, 0.25, 0)

	yield(get_tree().create_timer(0.5),"timeout")
	Globals.queue_dialog("mission_find_robot_discover_robot2")

func set_camera_enable(value):
	var cam_panel =  Globals.robot.get_node("ControlPanel/HUD/CameraPanel")
	var compass = Globals.robot.get_node("ControlPanel/HUD/CompassPanel")
	if value:
		cam_panel.enabled = true
		compass.show()
	else:
		cam_panel.enabled = false
		compass.hide()
		cam_panel._render_texture_to_hud(off_texture)

func end_game():
	set_camera_enable(false)
	var lidar_panel =  Globals.robot.get_node("ControlPanel/HUD/LidarPanel")
	var whisker_panel =  Globals.robot.get_node("ControlPanel/HUD/WhiskerPanel")

	roar_sound.play()
	
	Globals.robot.viewing_camera.get_node("CameraShaker").start(15, 50, 0.05, 0)
	Globals.robot.get_node("Robot").transform_overide = true
	var robot_body = Globals.robot.get_node("Robot")
	var tween = get_node("../Tween")	
	var dur1 = 1.0
	var dur2 =1.231
	var dur3 = 2.5
	var dur4 = 2.3
	tween.interpolate_property(robot_body,"global_transform",get_node("../BashedRobotPos0").global_transform,get_node("../BashedRobotPos1").global_transform,dur1,Tween.TRANS_ELASTIC ,Tween.EASE_OUT)#,tween.TRANS_BOUNCE)
	tween.interpolate_property(robot_body,"global_transform",get_node("../BashedRobotPos1").global_transform,get_node("../BashedRobotPos2").global_transform,dur2,Tween.TRANS_BACK,Tween.EASE_IN,dur1)#,tween.TRANS_BOUNCE)
	tween.interpolate_property(robot_body,"global_transform",get_node("../BashedRobotPos2").global_transform,get_node("../BashedRobotPos3").global_transform,dur3,Tween.TRANS_BOUNCE,Tween.EASE_OUT,dur1+dur2)#,tween.TRANS_BOUNCE)
	tween.interpolate_property(robot_body,"global_transform",get_node("../BashedRobotPos3").global_transform,get_node("../BashedRobotPos4").global_transform,dur3,Tween.TRANS_BOUNCE,Tween.EASE_OUT,dur1+dur2+dur3)#,tween.TRANS_BOUNCE)
	
	tween.start()
	yield(get_tree().create_timer(0.3),"timeout")
	
	yield(get_tree().create_timer(0.2),"timeout")
	
	set_camera_enable(true)
#
	yield(get_tree().create_timer(1.31),"timeout")
	whisker_panel.enabled = false
	whisker_panel._render_texture_to_hud(off_texture)
	
	yield(get_tree().create_timer(0.1),"timeout")
	set_camera_enable(false)
	lidar_panel.enabled = false
	lidar_panel._render_texture_to_hud(off_texture)
	yield(get_tree().create_timer(1.23),"timeout")
	set_camera_enable(true)
	
	yield(get_tree().create_timer(2.7),"timeout")
	set_camera_enable(false)
	
	yield(get_tree().create_timer(3.0),"timeout")
	
	Globals.control_panel_ui.fade_out()
	yield(get_tree().create_timer(2),"timeout")
	
	Globals.control_panel_ui.move_child(Globals.control_panel_ui.get_node("ObjectivePopup"),Globals.control_panel_ui.get_child_count())
	var mission = get_parent()
	
	mission.complete_mission()
	yield(get_tree().create_timer(6),"timeout")
	
	Globals.quit_to_main_menu()
