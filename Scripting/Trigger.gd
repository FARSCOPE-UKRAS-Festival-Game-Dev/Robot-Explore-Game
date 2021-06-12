extends Spatial
class_name Trigger

#Triggers emit the on_trigger signal when robot is in the area and a number of critera are satisfied

export(NodePath) var must_see = null 
var must_see_obj

const robot_action = preload("res://Robot/Robot_with_sensors.gd").robot_action
export(robot_action) var must_action #Action that robot must perform
export(bool) var on_trigger_action_is_success = true #Tell the robot is successful when this trigger is activated

export(NodePath) var must_whisker = null
var whisker_obj
#Custom criteria function can be used to augment trigger to only trigger when the specified function returns true
export(NodePath) var custom_criteria_object = null
export(String) var custom_criteria = null
var custom_criteria_func



export(bool) var enabled = false setget set_enable
export(bool) var oneshot = false #Oneshot triggers activate once

signal on_trigger
onready var must_see_enable = (must_see!=null) #NOT IMPLIMENTED
onready var must_action_enable = (must_action!=robot_action.NONE)
onready var must_whisker_enable = (must_whisker!= null)
onready var must_custom_enable = (custom_criteria_object!=null and custom_criteria!=null)
onready var must_see_timer = $MustSeeCheckTimer

var can_see = false
var doing_action = false
var obj_whiskered = false
var in_area = false

onready var globals = get_node('/root/Globals')

func on_whisker_object_sensed():
	var whisker_panel =  Globals.robot.get_node("ControlPanel/HUD/WhiskerPanel")
	yield(whisker_panel,"reveal_animation_finished")
	if Globals.robot.get_node("Robot/WhiskerSensor").get_current_sense_obj() == whisker_obj:
		obj_whiskered = true
		trigger()
		obj_whiskered = false
	
func _ready():
	if must_see_enable:
		must_see_obj = get_node(must_see)
	visible = visible and Globals.show_triggers
	if must_custom_enable:
		custom_criteria_func = funcref(get_node(custom_criteria_object),custom_criteria)


func check_robot_can_see():
	return Globals.robot.get_node("Robot/ForwardCameraSensor").can_see(must_see_obj)

func set_enable(value):
	enabled = value
	if enabled:
		trigger()

func trigger():
	var meets_criteria = in_area
	
	var debug_str = ""
	if must_see_enable:
		meets_criteria = meets_criteria and check_robot_can_see()
		debug_str += "Must See = %s " % meets_criteria
	if must_action_enable:
		meets_criteria = meets_criteria and doing_action
		debug_str += "Action = %s " % meets_criteria
	if must_custom_enable:
		meets_criteria = meets_criteria and custom_criteria_func.call_func()
		debug_str += "Custom Func = %s " % meets_criteria
	if must_whisker_enable:
		meets_criteria = meets_criteria and obj_whiskered
		debug_str += "Whisker = %s " % meets_criteria
		
	if Globals.trigger_debug and is_inside_tree():
		print("%s Triggered! - %s" % [get_parent().name + "/" +name,debug_str])
	if meets_criteria and enabled:
		emit_signal("on_trigger")
		if must_action_enable and on_trigger_action_is_success:
			globals.robot.on_action_activated_trigger(must_action,self)
		if oneshot:
			set_enable(false)
func _on_TriggerArea_body_entered(body):
	if body.get_name() == ("Robot"):
		in_area = true
		globals.robot.connect("doing_action",self,"_on_robot_action")
		if must_whisker_enable:
			whisker_obj = get_node(must_whisker)
			var whisker_obj_info = whisker_obj.get_node_or_null("TactileInfo")
			whisker_obj_info.connect("sensed_by_whiskers",self,"on_whisker_object_sensed")
		trigger()
		if must_see_enable:
			must_see_timer.start()

func _on_robot_action(action):
	if must_action_enable:
		doing_action = action==must_action
		trigger()
		doing_action = false
	if must_see_enable:
		must_see_timer.stop()

func _on_TriggerArea_body_exited(body):
	if body.get_name() == ("Robot"):
		in_area = false
		globals.robot.disconnect("doing_action",self,"_on_robot_action")
		if must_whisker_enable:
			whisker_obj = get_node(must_whisker)
			var whisker_obj_info = whisker_obj.get_node_or_null("TactileInfo")
			whisker_obj_info.disconnect("sensed_by_whiskers",self,"on_whisker_object_sensed")
