extends Control


onready var book_btn = $Panel/OpenBookButton

onready var book_unread_texture = preload("res://Assets/Images/ControlPanel/Options6_unread.png")
onready var book_read_texture = preload("res://Assets/Images/ControlPanel/Options6.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.init_control_panel()
	
	if not Globals.debug_mode:
		$MarginContainer/Panel/DebugTools.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta):
#	pass

func set_sensor_classes(mapping):
	if 'camera' in mapping:
		$Panel/CameraPanel.set_sensor_class(mapping['camera'])
	if 'lidar' in mapping:
		$Panel/LidarPanel.set_sensor_class(mapping['lidar'])
	
func _on_toggle_background_button(button):
	var bg = $Panel/Background
	bg.visible = button

func _on_ToggleHuds_toggled(button_pressed):
	$Panel.visible = button_pressed

func _on_OpenBookButton_toggled(button_pressed):
	# Open Book Menu! Globals.openMenu
	Globals.set_book_visible(button_pressed)
	mark_read_book_icon(true)

func mark_read_book_icon(read):
	book_btn.texture_normal =  book_read_texture if read else book_unread_texture
