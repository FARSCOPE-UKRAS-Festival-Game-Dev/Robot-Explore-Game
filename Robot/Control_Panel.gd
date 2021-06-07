extends Control

onready var hud = $HUD
onready var book_btn = hud.get_node("ButtonContainer/AspectRatioContainer/VBoxContainer/MarginContainer/OpenBookButton")
onready var special_menu =  hud.get_node("ButtonContainer/SpecialsMenu")

onready var book_unread_texture = preload("res://Assets/Images/ControlPanel/Options6_unread.png")
onready var book_read_texture = preload("res://Assets/Images/ControlPanel/Options6.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.init_control_panel()
	remove_isolate_panel()
	
	on_options_updated()

	Globals.connect("options_updated",self,"on_options_updated")

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
	var panel = hud.get_node(panel_name)
	var iso_panel = hud.get_node("IsolatingPanel")
	iso_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	
	Globals.joystick.hide()
	hud.move_child(iso_panel,hud.get_child_count()-1)
	hud.move_child(panel,hud.get_child_count()-1)
	hud.get_node("IsolatingPanel").show()

func remove_isolate_panel():
	var iso_panel = hud.get_node("IsolatingPanel")
	hud.move_child($HUD/ButtonContainer,hud.get_child_count())
	iso_panel.mouse_filter = Control.MOUSE_FILTER_PASS
	iso_panel.hide()
	Globals.joystick.show()
	
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

func _on_toggle_background_button(button):
	var bg = $HUD/Background
	bg.visible = button

func _on_ToggleHuds_toggled(button_pressed):
	$HUD.visible = button_pressed

func _on_OpenBookButton_toggled(button_pressed):
	# Open Book Menu! Globals.openMenu
	Globals.set_book_visible(button_pressed)
	mark_read_book_icon(true)

func mark_read_book_icon(read):
	book_btn.texture_normal =  book_read_texture if read else book_unread_texture


