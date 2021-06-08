extends Spatial
class_name ObjectiveBase

export(bool) var enabled = false setget set_enable
export(String) var display_text = "Objective" setget set_display_text,get_display_text
export(bool) var complete = false
export(bool) var disable_on_complete = false
export(String) var on_complete_dialogue = null
export(NodePath) var next_objective_enable = null
export var dialog_delay = 1.0

var id = 0


signal on_objective_complete(ObjectiveBase)
signal on_display_text_set 

signal enable_changed
signal on_enable
signal on_disable

signal on_dialog_displayed

onready var globals = get_node('/root/Globals')

func get_display_text():
	return display_text
func set_display_text(text):
	display_text = text
	emit_signal("on_display_text_set",text)

func set_hint_enable(value):
	for child in get_children():
		if child.name.match("Hint*"):
			child.enabled = value

func set_associated_dialog(value):

	for child in get_children():
		if child.name.match("Dialog*"):
			child.enabled = value

func set_enable(value):
	enabled = value
	emit_signal("enable_changed",value)
	if enabled:
		emit_signal("on_enable")
		
	else:
		emit_signal("on_disable")
	set_hint_enable(value)
	set_associated_dialog(value)
func display_dialog():
	globals.queue_dialog(on_complete_dialogue)
	emit_signal("on_dialog_displayed")

func complete_objective():
	if not complete:
		set_hint_enable(false)
		set_associated_dialog(false)
		complete = true

		if on_complete_dialogue!=null:
			#Adding short delay to completion dialogue looks nice
			get_tree().create_timer(dialog_delay).connect("timeout",self,"display_dialog")
			
		
		emit_signal("on_objective_complete",self)
		
		if next_objective_enable != null:
			if on_complete_dialogue:#wait for dialogue to finishe before enabling next objective
				yield(globals,"all_dialog_finished")
			get_node(next_objective_enable).set_enable(true)
		if disable_on_complete:
			set_enable(false)
			
