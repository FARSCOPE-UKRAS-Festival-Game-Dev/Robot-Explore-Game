extends Node

onready var mission = get_parent()

func _on_DialogFindItem2_dialog_triggered():
	yield(get_tree().create_timer(1.0),"timeout")
	yield(Globals,"all_dialog_finished")
	mission.enabled = true
	
