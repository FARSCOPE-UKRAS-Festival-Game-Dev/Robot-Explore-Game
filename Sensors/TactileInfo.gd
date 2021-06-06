extends Node

export(Texture) onready var value = load("res://Assets/Models/Textures/Rock015_1K_Color.png") setget ,on_sense
export(String) var texture_name = "Test"

signal sensed_by_whiskers

func on_sense():
	emit_signal("sensed_by_whiskers")
	return value
