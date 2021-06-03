extends Control
tool
export var complete = false setget set_complete
export var text = "Sub-Objective" setget set_text
export var sub_objective_prefix = "> "

func mark_complete(objective):
	print("complete!")
	set_complete(true)

func update_display_text(value):
	print("text set")
	value = sub_objective_prefix + value
	set_text(value)

func update_visibility(value):
	visible = value

func set_complete(value):
	var objective_text = get_node_or_null("HBoxContainer/ObjectiveText")
	var objective_tick =  get_node_or_null("HBoxContainer/AspectRatioContainer/CompleteTick")
	if objective_text != null and objective_tick!=null:
		objective_text.get_node("CrossoutLine").visible = value
		objective_tick.visible = value
		complete = value

func set_text(value):
	var objective_text = get_node_or_null("HBoxContainer/ObjectiveText")
	if objective_text != null:
		text = value  
		objective_text.text = value
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
