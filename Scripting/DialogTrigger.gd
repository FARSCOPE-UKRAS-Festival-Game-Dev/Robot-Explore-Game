extends TriggeredResource

#Triggers dialog when child trigger is triggered
export(String) var dialog = null
onready var globals = get_node('/root/Globals')
signal dialog_triggered
signal dialog_finished
var dialog_debounce = false

func check_dialog_finished(dialog_key):
	if dialog_key == dialog:
		emit_signal("dialog_finished")

func on_triggered():
	.on_triggered()
	print(dialog)
	if dialog != null and dialog_debounce == false:
		dialog_debounce = true
	
		Globals.connect("dialog_finished",self,"check_dialog_finished")
		globals.queue_dialog(dialog)
		emit_signal("dialog_triggered")
		yield(Globals,"all_dialog_finished")
		Globals.disconnect("dialog_finished",self,"check_dialog_finished")
		dialog_debounce = false
