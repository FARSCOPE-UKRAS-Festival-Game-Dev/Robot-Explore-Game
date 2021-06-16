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
	print("triggerd!")
	if one_shot:
		set_enabled(false)
		

func _ready():
	set_enabled(enabled)
	trigger_list = get_children()
	for child in trigger_list:
		if not child.name.match("Trigger"):
			trigger_list.erase(child)
			
	if not trigger_list.empty():
		for trigger in trigger_list:
			print("connecing %s to %s on_triggered" % [get_path_to(trigger),get_path()])
			trigger.connect("on_trigger",self,"on_triggered")#
	else:
		print("No valid triggers for : %s " % get_path())
