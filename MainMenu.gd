extends Control

export (String) var game_name = "The Best Robot Sensor Exploration Game"

export(Array, Array, String) var scene_locations = [

	["Tutorial - Final Environment", "res://Environments/TutorialSection/finalTutorialCave.tscn"],
	["Mission 1 - Final Environment", "res://Environments/MissionSection/finalMissionCave.tscn"],
#	["Cave Y Junction", "res://Environments/Cave_Y_Junction.tscn"],
#	["Testing Maze", "res://Environments/Testing_Maze.tscn"],
#	["Mission_testing", "res://Environments/Mission_Testing/Mission_testing.tscn"],
]

const dialog = preload("res://Utilities/Overlays/Textbox.tscn")
const CREDITS_SCENE = "res://Utilities/GodotCredits.tscn"

onready var globals = get_node('/root/Globals')
onready var selector_one = $MainMenu/MainPage/VBoxContainer/StartHBoxContainer/Selector
onready var selector_two = $MainMenu/MainPage/VBoxContainer/OptionsHBoxContainer/Selector
onready var selector_three = $MainMenu/MainPage/VBoxContainer/CreditsHBoX/Selector
onready var selector_four = $MainMenu/MainPage/VBoxContainer/ExitHBoxContainer/Selector
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
	$VersionLabel.text = str(ProjectSettings.get("application/config/version_tag"))

func _process(_delta):
	if Input.is_action_just_pressed("ui_down") and current_selection < 3:
		Globals.play_sound('switch_on')
		current_selection += 1
		set_current_selection(current_selection)
	elif Input.is_action_just_pressed("ui_up") and current_selection > 0:
		Globals.play_sound('switch_on')
		current_selection -= 1
		set_current_selection(current_selection)
	elif Input.is_action_just_pressed("ui_accept"):
		Globals.play_sound('switch_off')
		if not in_options:
			handle_selection(current_selection)
		else:
			hide_options()# Not implimenting options via keyboard atm

func handle_selection(_current_selection):
	Globals.play_sound('switch_on')
	if _current_selection == 0:
		Globals.load_new_scene(scene_locations[$DebugNode/MarginContainer/MapChoice.get_selected_id()][1])
	elif _current_selection == 1:
		show_options()
	elif _current_selection == 2:
		get_tree().change_scene(CREDITS_SCENE)
	elif _current_selection == 3:
		$FeedbackDialog.visible = true

func set_current_selection(_current_selection):
	if not in_options:
		selector_one.text = ""
		selector_two.text = ""
		selector_three.text = ""
		selector_four.text = ""

		if _current_selection == 0:
			selector_one.text = ">"
		elif _current_selection == 1:
			selector_two.text = ">"
		elif _current_selection == 2:
			selector_three.text = ">"
		elif _current_selection == 3:
			selector_four.text = ">"

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

func _on_Button3_pressed(): # Actually the exit button
	current_selection = 3 
	handle_selection(current_selection)

func _on_Button4_pressed(): # Actually the credits button
	current_selection = 2
	handle_selection(current_selection)

func _on_BackButton_pressed():
	Globals.play_sound('switch_off')
	hide_options()

func _on_ShowSensorButton_pressed():
	$AboutSensor.visible = true
	pass # Replace with function body.

func _on_AboutSensorCloseButton_pressed():
	$AboutSensor.visible = false
	pass # Replace with function body.

func leave_feedback():
	OS.shell_open("https://docs.google.com/forms/d/e/1FAIpQLSc2FomKHxIWh-J3w9nZ6f4RHcSYCkvTtYPYxsWKJw9PH9CmQg/viewform?usp=sf_link")
	exit_game()

func exit_game():
	get_tree().quit()
