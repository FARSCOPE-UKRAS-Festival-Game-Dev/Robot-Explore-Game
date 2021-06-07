extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.load_dialog_from_file("res://Assets/Dialog/dialog_testing_JSON.json")
