extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var menu_visible = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func toggle_menu_visible(toggle):
	$MarginContainer/VBoxContainer/DrillSampleButton.visible = toggle
	$MarginContainer/VBoxContainer/CollectSampleButton.visible = toggle
	$MarginContainer/VBoxContainer/TakeHighResPictureButton.visible = toggle
	$Panel.visible = toggle
	


func _on_OpenSpecialsButton_pressed():
	menu_visible=!menu_visible # Replace with function body.
	toggle_menu_visible(menu_visible)
