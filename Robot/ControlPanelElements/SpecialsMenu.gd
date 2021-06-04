extends Control


onready var background_full = $BackgroundPanel
onready var background = $MarginContainer/VBoxContainer/AspectRatioContainer/TopOnlyBackground
onready var button_container = $MarginContainer/VBoxContainer/AspectRatioContainer/MarginContainer/ButtonContainer

onready var open_button = $MarginContainer/VBoxContainer/MarginContainer/OpenSpecialsButton


signal drill_button_pressed
signal take_picture_button_pressed

func _ready():
	set_menu_visible(false)

func _on_DrillSampleButton_pressed():
	emit_signal("drill_button_pressed")
	set_menu_visible(false)

func _on_TakeHighResPictureButton_pressed():
	emit_signal("take_picture_button_pressed")
	set_menu_visible(false)

func set_menu_visible(visible):
	background.visible = visible
	button_container.visible = visible
	open_button.pressed = visible
func _on_OpenSpecialsButton_pressed():
	set_menu_visible(open_button.pressed)
