extends Spatial


export(NodePath) var must_see = null
export(String) var must_action = null

export(bool) var enabled = false

signal on_trigger
onready var must_see_enable = (must_see_enable!=null)
onready var must_action_enable = (must_action!=null)

var can_see = false
var doing_action = false
var in_area = false



func check_robot_can_see():
	pass

func trigger():
	var meets_criteria = true

	if must_see_enable:
		meets_criteria = meets_criteria and check_robot_can_see()
	
	if must_action_enable:
		meets_criteria = meets_criteria and doing_action

	meets_criteria = meets_criteria and in_area
	
	if meets_criteria and enabled:
		emit_signal("on_trigger")

func _ready():
	pass # Replace with function body.


func _on_TriggerArea_body_entered(body):

	if body.get_name() == ("Robot"):
		in_area = true
		trigger()

func _on_robot_action(action):
	if must_action_enable:
		doing_action = action==must_action
		trigger()
		doing_action = false
	
func _on_TriggerArea_body_exited(body):
	if body.get_name() == ("Robot"):
		in_area = false
		#trigger()
