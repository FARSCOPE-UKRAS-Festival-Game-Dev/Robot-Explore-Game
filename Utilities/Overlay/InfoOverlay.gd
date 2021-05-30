extends Control

onready var overlay_tabs = $HBoxContainer/OverlayTabs

onready var mission_vbox = overlay_tabs.get_node("MissionVBox")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	overlay_tabs.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TextureButton_toggled(button_pressed):
	$HBoxContainer/OverlayTabs.visible = button_pressed

func add_mission(mission_title,mission_desc,objective):
	var	mission = load("res://Scenes/House.tscn")
	mission.instance()
	mission_vbox.add_child(mission)
