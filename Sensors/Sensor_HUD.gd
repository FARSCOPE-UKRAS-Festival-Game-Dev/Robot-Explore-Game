extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var SCALE_FACTOR = 0.1
var DEAD_ZONE = 0.1
var joystick_control = null
var camera_feed = null
# Called when the node enters the scene tree for the first time.
func _ready():
	joystick_control = find_node ("Joystick")
	camera_feed =find_node ("Camera_feed")
func simulate_event(event,strength,active = true):
	var ev = InputEventAction.new()

	ev.pressed = active
	ev.action  = event	
	ev.strength = strength
	Input.parse_input_event(ev)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#Mimic the WASD controls with the virtual joystick, we do this using gadot's input events
	if joystick_control.joystick_vector.length() < DEAD_ZONE:
		simulate_event("accelerate",1.0,false)
		simulate_event("reverse",1.0,false)
	else:
		if joystick_control.joystick_vector.y > 0 :
			simulate_event("accelerate",abs(joystick_control.joystick_vector.y)*SCALE_FACTOR)
		elif joystick_control.joystick_vector.y < 0:
			simulate_event("reverse",abs(joystick_control.joystick_vector.y)*SCALE_FACTOR)
			
		var left_steer_strength =  clamp(joystick_control.joystick_vector.x,0.0,1.0)
		var right_steer_strength =  abs(clamp(joystick_control.joystick_vector.x,-1.0,0.0))
	
		simulate_event("turn_left",left_steer_strength)
		simulate_event("turn_right",right_steer_strength)
func set_render_target(target_texture):
	camera_feed.texture = target_texture 


func _on_Joystick_Joystick_Stop():
 pass


