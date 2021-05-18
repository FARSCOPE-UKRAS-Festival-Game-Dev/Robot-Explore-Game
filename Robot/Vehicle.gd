extends VehicleBody

const STEER_SPEED = 1.5
const STEER_LIMIT = 0.4

var steer_target = 0

export var engine_force_value = 40

# Joystick node
var joystick
var is_joystick_enabled

func _ready() -> void:
	var globals = get_node('/root/Globals')
	joystick = globals.joystick
	is_joystick_enabled = globals.is_joystick_enabled

func _physics_process(delta):
	var fwd_mps = transform.basis.xform_inv(linear_velocity).x

	steer_target = Input.get_action_strength("turn_left") - Input.get_action_strength("turn_right")
	steer_target *= STEER_LIMIT
	
	# Touchscreen joystick input override
	if is_joystick_enabled:
		steer_target = joystick.output.x * -1
		steer_target *= STEER_LIMIT

	if Input.is_action_pressed("accelerate") or joystick.output.y < 0:
		# Increase engine force at low speeds to make the initial acceleration faster.
		var speed = linear_velocity.length()
		if speed < 5 and speed != 0:
			engine_force = clamp(engine_force_value * 5 / speed, 0, 100)
		else:
			engine_force = engine_force_value
	else:
		engine_force = 0

	if Input.is_action_pressed("reverse") or joystick.output.y > 0:
		# Increase engine force at low speeds to make the initial acceleration faster.
		if fwd_mps >= -1:
			var speed = linear_velocity.length()
			if speed < 5 and speed != 0:
				engine_force = -clamp(engine_force_value * 5 / speed, 0, 100)
			else:
				engine_force = -engine_force_value
		else:
			brake = 1
	else:
		brake = 0.0
	
	#print("AE: " + str(steering) + " : " + str(steer_target) + " : " + str(STEER_SPEED * delta) + " : " + str(transform))

	var robot_rotation = get_rotation_degrees()
	#print("AE: " + str(robot_rotation))
	if (abs(robot_rotation.z) > 80):
		set_rotation_degrees(Vector3(robot_rotation.x, robot_rotation.y, 0))
	elif (abs(robot_rotation.x) > 80):
		set_rotation_degrees(Vector3(0, robot_rotation.y, robot_rotation.z))
		
	steering = move_toward(steering, steer_target, STEER_SPEED * delta)
