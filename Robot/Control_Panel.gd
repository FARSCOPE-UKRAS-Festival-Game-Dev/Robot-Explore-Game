extends Control

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
		$Panel/CameraPanel.set_camera_sensor_class(mapping['camera'])
	
func _on_toggle_background_button(button):
	var bg = $Panel/Background
	bg.visible = button

func _on_ToggleHuds_toggled(button_pressed):
	$Panel.visible = button_pressed

func _on_OpenBookButton_pressed():
	# Open Book Menu! Globals.openMenu
	pass # Replace with function body.
