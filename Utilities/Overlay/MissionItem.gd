extends MarginContainer


onready var name_txtbox = $Panel/VBoxContainer/MissionName
onready var description_txtbox = $Panel/VBoxContainer/MissionDescription
onready var subobjective_container = $Panel/VBoxContainer/SubObjectives/VBoxContainer

export var mission_name = "Mission" setget set_mission_name, get_mission_name

func set_mission_name(new_name):
	name_txtbox.text = new_name
	mission_name = new_name
	
func get_mission_name():
	return name_txtbox.text
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
