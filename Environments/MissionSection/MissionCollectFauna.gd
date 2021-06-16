extends Node




func _on_MissionStartTrigger_on_trigger():
	Globals.queue_dialog("mission_fauna_got_start")
	yield(Globals,"all_dialog_finished")
	yield(get_tree().create_timer(1.0),"timeout")
	var mission = get_parent()
	mission.enabled = true
	
	
