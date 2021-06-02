extends Node
class_name ObjectiveBase

export(bool) var enabled = false setget set_enable
export(String) var display_text = "Objective" setget set_display_text,get_display_text
export(bool) var complete = false
export(bool) var disable_on_complete = false
export(String) var on_complete_dialogue = null
export(NodePath) var next_objective_enable = null
export var id = 0
export var dialog_delay = 1.0

signal on_objective_complete
signal on_display_text_set 

signal enable_changed
signal on_enable
signal on_disable

onready var globals = get_node('/root/Globals')

func get_display_text():
	return display_text
func set_display_text(text):
	display_text = text
	emit_signal("on_display_text_set",text)

func set_enable(value):
	enabled = value
	emit_signal("enable_changed",value)
	if enabled:
		emit_signal("on_enable")
	else:
		emit_signal("on_disable")
		
func complete_objective():
	if not complete:
		
		complete = true

		var robot =  get_tree().get_root().get_node("TankRobot_with_sensors")
		if on_complete_dialogue!=null:
			get_tree().create_timer(dialog_delay).connect("timeout",globals,"queue_dialog",[on_complete_dialogue,])
		if next_objective_enable != null:
			get_node(next_objective_enable).enabled = true
		if disable_on_complete:
			set_enable(false)
			
		emit_signal("on_objective_complete",self)

