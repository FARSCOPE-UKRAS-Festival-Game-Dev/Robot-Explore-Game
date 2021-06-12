extends Node
onready var calibration_body = get_node("../../TemperatureCalibrationBody")
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
	Globals.queue_dialog("mission_start_1")
	yield(Globals,"all_dialog_finished")
	yield(get_tree().create_timer(1.0),"timeout")
	get_node("../LocateRobot").enabled = true


func _on_LocateRobot_on_objective_complete(ObjectiveBase):
	Globals.queue_dialog("mission_find_robot_discover_robot")
	yield(Globals,"all_dialog_finished")
	yield(get_tree().create_timer(1.0),"timeout")
	var steps = get_node("../Audio/YetiSteps").play()
	Globals.robot.viewing_camera.get_node("CameraShaker").start(10, 15, 0.25, 0)
	yield(get_tree().create_timer(0.5),"timeout")
	Globals.queue_dialog("mission_find_robot_discover_robot2")
	yield(get_tree().create_timer(2),"timeout")
	Globals.control_panel_ui.fade_out()
	yield(get_tree().create_timer(5),"timeout")
	get_tree().change_scene("res://MainMenu.tscn")
