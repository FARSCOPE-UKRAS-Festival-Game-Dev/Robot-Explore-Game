extends Spatial
class_name Trigger

#Triggers emit the on_trigger signal when robot is in the area and a number of critera are satisfied

#export(NodePath) var must_see = null #NOT IMPLIMENTED

const robot_action = preload("res://Robot/Robot_with_sensors.gd").robot_action

export(robot_action) var must_action #Action that robot must perform

export(bool) var enabled = false

signal on_trigger
onready var must_see_enable = false#(must_see_enable!=null) #NOT IMPLIMENTED
onready var must_action_enable = (must_action!=robot_action.NONE)


var can_see = false
var doing_action = false
var in_area = false

onready var globals = get_node('/root/Globals')

func _ready():
	visible = false

func check_robot_can_see():
	#NOT IMPLIMENTED
	pass

func trigger():
	var meets_criteria = in_area

	if must_see_enable:
		meets_criteria = meets_criteria and check_robot_can_see()
	
	if must_action_enable:
		meets_criteria = meets_criteria and doing_action

	meets_criteria = meets_criteria and in_area
	
	if meets_criteria and enabled:
		emit_signal("on_trigger")

func _on_TriggerArea_body_entered(body):
	if body.get_name() == ("Robot"):
		in_area = true
		globals.robot.connect("doing_action",self,"_on_robot_action")
		trigger()

func _on_robot_action(action):
	if must_action_enable:
		doing_action = action==must_action
		trigger()
		doing_action = false
	
func _on_TriggerArea_body_exited(body):
	if body.get_name() == ("Robot"):
		in_area = false
		globals.robot.disconnect("doing_action",self,"_on_robot_action")
