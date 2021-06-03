extends TriggeredResource

#Triggers dialog when child trigger is triggered
export(String) var dialog = null
onready var globals = get_node('/root/Globals')

func on_triggered():
	if dialog != null:
		globals.queue_dialog(dialog)
		
