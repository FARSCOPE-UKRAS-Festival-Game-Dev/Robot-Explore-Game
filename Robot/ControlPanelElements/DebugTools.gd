extends Control


func _ready():
	if Globals.robot != null:
		$Panel/HBoxContainer/ToggleBackground.connect("toggled",Globals.robot.get_node("ControlPanel"),"set_background_visible")
		$Panel/HBoxContainer/ToggleHUD.connect("toggled",Globals.robot.get_node("ControlPanel"),"set_HUD_visible")
		$Panel/HBoxContainer/FastMode.connect("toggled",self,"set_fast_mode")
	
func set_fast_mode(value):
	if value: 
		Globals.robot.get_node("Robot").speed*=5.0
		Globals.robot.get_node("Robot").rot_speed*=5
	else:
		Globals.robot.get_node("Robot").speed/=5.0
		Globals.robot.get_node("Robot").rot_speed/=5.0

