extends Spatial

var objective_list = []


export var complete = false

export var mission_name = "Mission1"
export var mission_desc = "Mission1 - description" 
export(String) var on_complete_dialogue = null


signal subobjective_completed
signal mission_completed

onready var globals = get_node('/root/Globals')

func _ready():
	var objective_id = 0
	for child in get_children():
		if child.is_in_group("Objectives"):
			child.id = objective_id
			objective_list.append(child)
			child.connect("on_objective_complete",self,"on_objective_complete")
	
func check_complete():
	for objective in objective_list:
		if not objective.complete:
			complete = false
			return complete
	complete = true
	return complete
	
func on_objective_complete(objective):
	
	print("Objective complete")
	emit_signal("subobjective_completed")
	if check_complete() == true:
		emit_signal("mission_completed")
		if on_complete_dialogue!=null:
			print("dialog being displayed")
			#Queue dialog after final objectives dialog
			objective.connect("on_dialog_displayed",globals,"queue_dialog",[on_complete_dialogue,])
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
