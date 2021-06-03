extends Node

export(String) var dialog = null
onready var globals = get_node('/root/Globals')

func trigger_dialog():
	if dialog != null:
		globals.queue_dialog(dialog)
	
