extends Control


const robot_action = preload("res://Robot/Robot_with_sensors.gd").robot_action

var isolating_panel

onready var hud = $HUD
onready var book_btn = hud.get_node("ButtonContainer/AspectRatioContainer/VBoxContainer/MarginContainer/OpenBookButton")
onready var special_menu =  hud.get_node("ButtonContainer/SpecialsMenu")

onready var book_unread_texture = preload("res://Assets/Images/ControlPanel/Options6_unread.png")
onready var book_read_texture = preload("res://Assets/Images/ControlPanel/Options6.png")

const CAMERA_HIGH_RES_SCENE = preload("res://Utilities/Misc/ShowHighResPhoto.tscn")

signal finished_action_anim(action_string)
# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.init_control_panel()
	remove_isolate_panel()
	
	on_options_updated()

	Globals.connect("options_updated",self,"on_options_updated")

func _process(delta):
	var speed = Globals.robot.get_node("Robot").velocity.length()
	$HUD/Speedometer/Label.text = "%.1f m/s" % speed

func _exit_tree():
	Globals.free_control_panel()

func on_options_updated():
	if not Globals.debug_mode:
		$DebugTools.visible = false
	else:
		$DebugTools.visible = true

func set_background_visible(value):
	hud.get_node("Background").visible = value
	
func set_HUD_visible(value):
	hud.visible = value
	
func isolate_panel(panel_name):
	isolating_panel = true
	Globals.robot.immobilise = true
	var panel = hud.get_node(panel_name)
	var iso_panel = hud.get_node("IsolatingPanel")
	iso_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	
	Globals.joystick.set_visible(false)
	hud.move_child(iso_panel,hud.get_child_count()-1)
	hud.move_child(panel,hud.get_child_count()-1)
	
	hud.get_node("IsolatingPanel").show()

func remove_isolate_panel():
	isolating_panel= false
	var iso_panel = hud.get_node("IsolatingPanel")
	
	hud.move_child($HUD/CompassPanel,hud.get_child_count())
	hud.move_child($HUD/ButtonContainer,hud.get_child_count())

	iso_panel.mouse_filter = Control.MOUSE_FILTER_PASS
	iso_panel.hide()
	Globals.joystick.set_visible(true)
	if Globals.displaying_dialog == false:
		Globals.robot.immobilise = false
	
func set_sensor_classes(mapping):
	if 'camera' in mapping:
		hud.get_node("CameraPanel").set_sensor_class(mapping['camera'])
	if 'lidar' in mapping:
		hud.get_node("LidarPanel").set_sensor_class(mapping['lidar'])
	if 'whisker' in mapping:
		$HUD/WhiskerPanel.set_sensor_class(mapping['whisker'])
	if 'templeft' in mapping:
		$HUD/TemperaturePanelLeft.set_sensor_class(mapping['templeft'])
	if 'tempright' in mapping:
		$HUD/TemperaturePanelRight.set_sensor_class(mapping['tempright'])
	if 'compass' in mapping:
		$HUD/CompassPanel.set_sensor_class(mapping['compass'])

func _on_toggle_background_button(button):
	var bg = $HUD/Background
	bg.visible = button

func _on_ToggleHuds_toggled(button_pressed):
	$HUD.visible = button_pressed

func _on_OpenBookButton_toggled(button_pressed):
	# Open Book Menu! Globals.openMenu
	Globals.set_book_visible(button_pressed)
	Globals.joystick.set_visible(not button_pressed)
	mark_read_book_icon(true)

func mark_read_book_icon(read):
	book_btn.texture_normal =  book_read_texture if read else book_unread_texture

func _on_SpecialsMenu_collect_sample_button_pressed():
	Globals.robot.immobilise = true
	Globals.play_sound("robot_arm", -15.0)
	Globals.robot.viewing_camera.get_node("CameraShaker").start(2.0, 100, 0.05, 0)
	special_menu.show_spinner_duration(2.0)
	yield(get_tree().create_timer(2.0), "timeout")
	emit_signal("finished_action_anim",robot_action.COLLECT_SAMPLE)
	if Globals.displaying_dialog == false:
		Globals.robot.immobilise = false
func _on_SpecialsMenu_drill_button_pressed():
	Globals.robot.immobilise = true
	Globals.play_sound("drill_success", -15.0)
	Globals.robot.viewing_camera.get_node("CameraShaker").start(10.0, 15, 0.2, 0)
	special_menu.show_spinner_duration(10.0)
	yield(get_tree().create_timer(10.0), "timeout")
	emit_signal("finished_action_anim",robot_action.DRILL_SAMPLE)
	if Globals.displaying_dialog == false:
		Globals.robot.immobilise = false
func _on_SpecialsMenu_take_picture_button_pressed():
	Globals.robot.immobilise = true
	var high_res_cam_node = CAMERA_HIGH_RES_SCENE.instance()
	add_child(high_res_cam_node)
	var robot_transform = Globals.robot.get_camera_transform()
	high_res_cam_node.take_picture(robot_transform, 3.0)
	yield(get_tree().create_timer(3.0), "timeout")
	emit_signal("finished_action_anim",robot_action.TAKING_PICTURE)
	if Globals.displaying_dialog == false:
		Globals.robot.immobilise = false
