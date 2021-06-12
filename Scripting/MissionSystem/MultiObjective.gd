extends ObjectiveBase

class_name MultiObjective 
#Objective consisting of many sub-objectives
var objective_components


var num_complete setget ,get_num_complete
var component_total = 0
var display_text_format

export(int) var num_must_complete = null #Number of the child objectives must be completed to mark as complete.
export var disable_last_dialogue = true # Disable last dialog useful if objectives aren't chronological

signal on_component_complete

func set_enable(value):
	.set_enable(value)
	
	for component in get_components():
		component.set_enable(value)
		
func get_components():
	objective_components = []
	for child in get_children():
		if child.is_in_group("Objectives"):
			objective_components.append(child)
	return objective_components

func get_num_complete():
	var complete_count = 0
	for objective in objective_components:
		if objective.complete:
			complete_count+=1
	return complete_count

func get_incomplete():
	var incomplete_components = []
	for objective in objective_components:
		if not objective.complete:
			incomplete_components.append(objective)
	return incomplete_components

func get_display_text():

	display_text = display_text_format + " ({complete}/{total})".format({"complete" : get_num_complete(),"total" : component_total})
	return display_text

func _ready():
	for component in get_components():
		component.connect("on_objective_complete",self,"on_component_complete")
	if num_must_complete == null:
		component_total = len(objective_components)
	else:
		component_total = num_must_complete
	display_text_format = display_text
	
func on_component_complete(_sub_obj_id):
	emit_signal("on_display_text_set",get_display_text())
	
	if disable_last_dialogue and (component_total - get_num_complete() == 1):
		var last_components = get_incomplete()
		for component in last_components:
			component.on_complete_dialogue = null
		
	if get_num_complete() >= component_total:
		complete_objective()
		for objective in objective_components:
			objective.enabled = false
	emit_signal("on_component_complete")	
