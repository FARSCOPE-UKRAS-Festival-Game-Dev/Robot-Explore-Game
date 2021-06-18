extends Spatial
class_name TriggeredResource 
export(bool) var enabled = true setget set_enabled

var trigger_list = null
export var one_shot = false

func set_enabled(value):
	enabled = value

	if trigger_list != null:
		for trigger in trigger_list:
			trigger.enabled = enabled

func on_triggered():
	if one_shot:
		set_enabled(false)
		

func _ready():

	trigger_list = []
	for child in get_children():
		if child.name.match("Trigger*"):
			trigger_list.append(child)
			
	if not trigger_list.empty():
		for trigger in trigger_list:
			trigger.connect("on_trigger",self,"on_triggered")#
	else:
		print("No valid triggers for : %s " % get_path())
	set_enabled(enabled)
