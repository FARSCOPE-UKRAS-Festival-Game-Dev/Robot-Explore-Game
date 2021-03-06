extends MarginContainer

onready var name_txtbox = $Panel/VBoxContainer/MissionName  
onready var description_txtbox = $Panel/VBoxContainer/MissionDescription
onready var subobjective_container = $Panel/VBoxContainer/SubObjectives/VBoxContainer

export var complete = false
export var mission_name = "Mission" setget set_name
export var mission_description = "This is a mission description" setget set_description

onready var sub_objective_lbl = subobjective_container.get_node("Sub-Objective1").duplicate()

var objective_labels = []

func set_name(name):
	name_txtbox.text = name
	
func set_description(desc):
	description_txtbox.text = desc

func set_sub_objectives(objective_list):
	for objective in subobjective_container.get_children():
		objective.queue_free()
	for objective in objective_list:
		var new_lbl = sub_objective_lbl.duplicate()
		new_lbl.update_display_text(objective.display_text)
		subobjective_container.add_child(new_lbl)
		objective_labels.append(new_lbl)

func update_visibility(value):
	visible = value
	
func on_mission_complete():
	set_name("[COMPLETED] - " + mission_name)
	complete = true



# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
