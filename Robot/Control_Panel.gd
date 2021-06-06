extends Control


onready var book_btn = $HUD/HBoxContainer/VBoxContainer/MarginContainer/OpenBookButton
onready var SpecialMenu = $HUD/HBoxContainer/SpecialsMenu

onready var book_unread_texture = preload("res://Assets/Images/ControlPanel/Options6_unread.png")
onready var book_read_texture = preload("res://Assets/Images/ControlPanel/Options6.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.init_control_panel()
	
	if not Globals.debug_mode:
		$DebugTools.visible = false
	else:
		$DebugTools/Panel/ToggleBackground.connect("toggled",self,"set_background_visible")
		$DebugTools/Panel/ToggleHUD.connect("toggled",self,"set_HUD_visible")

func set_background_visible(value):
	$HUD/Background.visible = value
	
func set_HUD_visible(value):
	$HUD.visible = value
	

func set_sensor_classes(mapping):
	if 'camera' in mapping:
		$HUD/CameraPanel.set_sensor_class(mapping['camera'])
	if 'lidar' in mapping:
		$HUD/LidarPanel.set_sensor_class(mapping['lidar'])
	if 'whisker' in mapping:
		$HUD/WhiskerPanel.set_sensor_class(mapping['whisker'])
		
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
