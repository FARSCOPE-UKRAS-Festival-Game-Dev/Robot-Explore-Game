extends Spatial

var objective_list = []


export var complete = false
export var enabled = true setget set_enable

export var mission_name = "Mission1"
export var mission_desc = "Mission1 - description" 
export(String) var on_complete_dialogue = null

signal enabled_changed(enabled)
signal subobjective_completed
signal mission_completed

onready var globals = get_node('/root/Globals')
var objective_enabled_state = []

func set_enable(value):
	enabled = value
	emit_signal("enabled_changed",value)
	if enabled:
		revert_objective_enabled_state()
	else:
		for child in get_children():
			if child.is_in_group("Objectives"):
				child.enabled = false
func revert_objective_enabled_state():
	var objective_id = 0
	for objective in objective_list:
		objective.enabled = objective_enabled_state[objective_id]
		objective_id+=1
	
func _ready():
	var objective_id = 0
	for child in get_children():
		if child.is_in_group("Objectives"):
			objective_enabled_state.append(child.enabled)
			
			child.id = objective_id
			objective_list.append(child)
			child.connect("on_objective_complete",self,"on_objective_complete")
			objective_id+=1

func check_complete():
	for objective in objective_list:
		if not objective.complete:
			complete = false
			return complete
	complete = true
	return complete
	
func on_objective_complete(objective):
	
	emit_signal("subobjective_completed")
	if check_complete() == true:
		emit_signal("mission_completed")
		if on_complete_dialogue!=null:
			#Queue dialog after final objectives dialog
			objective.connect("on_dialog_displayed",globals,"queue_dialog",[on_complete_dialogue,])
