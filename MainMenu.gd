extends Control

export (String) var game_name = "The Best Robot Sensor Exploration Game"

export(Array, Array, String) var scene_locations = [
	["Mission 1 alpha", "res://Environments/Mission_1.tscn"],
	["Cave Y Junction", "res://Environments/Cave_Y_Junction.tscn"],
	["Testing Maze", "res://Environments/Testing_Maze.tscn"],
	["Mission_testing", "res://Environments/Mission_testing.tscn"]
]

const dialog = preload("res://Utilities/Overlays/Textbox.tscn")

onready var globals = get_node('/root/Globals')
onready var selector_one = $MainMenu/MainPage/VBoxContainer/CenterContainer/HBoxContainer/Selector
onready var selector_two = $MainMenu/MainPage/VBoxContainer/CenterContainer2/HBoxContainer/Selector
onready var selector_three = $MainMenu/MainPage/VBoxContainer/CenterContainer3/HBoxContainer/Selector
onready var main_menu = $MainMenu/MainPage

var current_selection = 0
var in_options = false
onready var options_menu = $MainMenu/OptionPage/
func _ready():
	set_current_selection(0)
	
#	$CenterContainer/VBoxContainer/VBoxContainer/CenterContainer/Label.text = game_name
	hide_options()
	if !globals.debug_mode:
		$DebugNode.visible = false
	
	for maps in scene_locations:
		$DebugNode/MarginContainer/MapChoice.add_item(maps[0])

	
func _process(_delta):
	if Input.is_action_just_pressed("ui_down") and current_selection < 2:
		current_selection += 1
		set_current_selection(current_selection)
	elif Input.is_action_just_pressed("ui_up") and current_selection > 0:
		current_selection -= 1
		set_current_selection(current_selection)
	elif Input.is_action_just_pressed("ui_accept"):
		if not in_options:
			handle_selection(current_selection)
		else:
			hide_options()# Not implimenting options via keyboard atm
func handle_selection(_current_selection):
	if _current_selection == 0:
		get_tree().change_scene(scene_locations[$DebugNode/MarginContainer/MapChoice.get_selected_id()][1])
		#get_parent().add_child(scene.instance())
		#queue_free()
	elif _current_selection == 1:
		show_options()
	elif _current_selection == 2:
		get_tree().quit()

func set_current_selection(_current_selection):
	if not in_options:
		selector_one.text = ""
		selector_two.text = ""
		selector_three.text = ""

		if _current_selection == 0:
			selector_one.text = ">"
		elif _current_selection == 1:
			selector_two.text = ">"
		elif _current_selection == 2:
			selector_three.text = ">"

func show_options():
	in_options = true
	options_menu.show()
	main_menu.hide()
	
func hide_options():
	in_options = false
	options_menu.hide()
	main_menu.show()
	
func _on_Button_pressed():
	current_selection = 0
	handle_selection(current_selection)


func _on_Button2_pressed():
	current_selection = 1
	handle_selection(current_selection)
	

func _on_Button3_pressed():
	current_selection = 2
	handle_selection(current_selection)


func _on_BackButton_pressed():
	hide_options()

