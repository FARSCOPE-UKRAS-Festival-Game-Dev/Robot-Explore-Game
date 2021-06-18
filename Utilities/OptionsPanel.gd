extends MarginContainer

signal options_updated

export var show_quit_to_main_menu = true

onready var font = load("res://Assets/Fonts/NormalTextFont.tres")
func _on_FontSlider_value_changed(value):
	
	font.size = int(value)

func set_volume(value):
	var fin_val = -($GridContainer/VolumeSlider.max_value - value) + 1
	print('volume set to ', value, fin_val)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), fin_val)

func _on_VolumeSlider_value_changed(value):
	set_volume(value)

func _ready():
	set_volume($GridContainer/VolumeSlider.value)
#	$GridContainer/VolumeSlider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	$GridContainer/FontSlider.value = font.size
	$GridContainer/Debug_tools.pressed = Globals.debug_mode
	
	$GridContainer/QuitButton.visible = show_quit_to_main_menu
		
func _on_Debug_tools_toggled(button_pressed):
	Globals.debug_mode = button_pressed
	

func _on_OptionsPanel_visibility_changed():
	Globals.on_options_updated()


func _on_QuitButton_pressed():
	Globals.quit_to_main_menu()
	pass # Replace with function body.
