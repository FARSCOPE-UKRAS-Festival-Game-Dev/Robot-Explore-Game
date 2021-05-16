extends MarginContainer

const scene = preload("res://Environments/Testing_Cave_2.tscn")
const dialog = preload("res://Utilities/Textbox.tscn")

onready var selector_one = $CenterContainer/VBoxContainer/VBoxContainer/CenterContainer/HBoxContainer/Selector
onready var selector_two = $CenterContainer/VBoxContainer/VBoxContainer/CenterContainer2/HBoxContainer/Selector
onready var selector_three = $CenterContainer/VBoxContainer/VBoxContainer/CenterContainer3/HBoxContainer/Selector

var current_selection = 0

func _ready():
	set_current_selection(0)
	
func _process(delta):
	if Input.is_action_just_pressed("ui_down") and current_selection < 2:
		current_selection += 1
		set_current_selection(current_selection)
	elif Input.is_action_just_pressed("ui_up") and current_selection > 0:
		current_selection -= 1
		set_current_selection(current_selection)
	elif Input.is_action_just_pressed("ui_accept"):
		handle_selection(current_selection)

func handle_selection(_current_selection):
	if _current_selection == 0:
		get_parent().add_child(scene.instance())
		queue_free()
	elif _current_selection == 1:
		get_parent().add_child(dialog.instance())
		queue_free()
	elif _current_selection == 2:
		get_tree().quit()

func set_current_selection(_current_selection):
	selector_one.text = ""
	selector_two.text = ""
	selector_three.text = ""

	if _current_selection == 0:
		selector_one.text = ">"
	elif _current_selection == 1:
		selector_two.text = ">"
	elif _current_selection == 2:
		selector_three.text = ">"


func _on_Button_pressed():
	current_selection = 0
	handle_selection(current_selection)


func _on_Button2_pressed():
	current_selection = 1
	handle_selection(current_selection)
	

func _on_Button3_pressed():
	current_selection = 2
	handle_selection(current_selection)
