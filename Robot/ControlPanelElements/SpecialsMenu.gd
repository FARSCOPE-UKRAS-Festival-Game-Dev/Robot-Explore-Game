extends Control

const SPINNER_SCENE = preload("res://Utilities/Misc/WaitingSpinner.tscn")

onready var background_full = $BackgroundPanel
onready var background = $AspectRatioContainer/MarginContainer/VBoxContainer/AspectRatioContainer/TopOnlyBackground
onready var button_container = $AspectRatioContainer/MarginContainer/VBoxContainer/AspectRatioContainer/MarginContainer/ButtonContainer

onready var open_button = $AspectRatioContainer/MarginContainer/VBoxContainer/MarginContainer/OpenSpecialsButton

signal drill_button_pressed
signal take_picture_button_pressed
signal collect_sample_button_pressed

func _ready():
	set_menu_visible(false)

func _on_DrillSampleButton_pressed():
	play_button(false)
	emit_signal("drill_button_pressed")
	set_menu_visible(false)

func _on_TakeHighResPictureButton_pressed():
	play_button(false)
	emit_signal("take_picture_button_pressed")
	set_menu_visible(false)

func _on_TakeSampleButtom_pressed():
	emit_signal("collect_sample_button_pressed")
	set_menu_visible(false)

func set_menu_visible(visible):
	background.visible = visible
	button_container.visible = visible
	open_button.pressed = visible
	
func _on_OpenSpecialsButton_pressed():
	play_button(open_button.pressed)
	set_menu_visible(open_button.pressed)

func play_button(on):
	if on:
		$ButtonToggleOnAudio.play()
	else:
		$ButtonToggleOffAudio.play()

func show_spinner_duration(duration):
	var spin_inst = SPINNER_SCENE.instance()
	spin_inst.duration_seconds = duration
	open_button.get_node("Spinner").add_child(spin_inst)
