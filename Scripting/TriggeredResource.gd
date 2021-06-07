extends Spatial
class_name TriggeredResource 
export(bool) var enabled = true setget set_enabled

var trigger 

func set_enabled(value):
	enabled = value
	if trigger != null:
		trigger.enabled = enabled

func on_triggered():
	print("this isn't being overridden")
	

func _ready():
	set_enabled(enabled)
	trigger = get_node_or_null("Trigger")
	if trigger != null:
		trigger.connect("on_trigger",self,"on_triggered")
