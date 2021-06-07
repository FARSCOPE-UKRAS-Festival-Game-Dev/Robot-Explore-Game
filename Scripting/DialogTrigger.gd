extends TriggeredResource

#Triggers dialog when child trigger is triggered
export(String) var dialog = null
onready var globals = get_node('/root/Globals')

var dialog_debounce = false


func on_triggered():
	if dialog != null and dialog_debounce == false:
		dialog_debounce = true
		globals.queue_dialog(dialog)
		yield(Globals,"all_dialog_finished")
		dialog_debounce = false
