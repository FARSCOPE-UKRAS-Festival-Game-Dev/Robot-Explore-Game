extends KinematicBody


export var gravity = Vector3.UP * -4
export var speed = 2
export var rot_speed = 0.60
export var max_floor_angle_degrees = 30

export var engine_power = 3.0
export var braking = -9.0
export var friction = -2.0
export var drag = -2.0
export var max_speed_reverse = 3.0
export var max_velocity = 5.0

# Car state properties
var acceleration = Vector3.ZERO  # current acceleration
var velocity = Vector3.ZERO  # current velocity
var wheel_base

var wheel_vel = Vector2.ZERO
var accel_vel = Vector2.ZERO # Controlled by player

var joystick
var is_joystick_enabled: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	joystick = Globals.joystick
	is_joystick_enabled = Globals.is_joystick_enabled
#	wheel_base = ($Body/Track1.transform.origin - $Body/Track2.transform.origin).length()
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#func _physics_process(delta):
#	get_input(delta)
#	if is_on_floor():
#		apply_friction(delta)
#		calculate_steering(delta)
#
#	acceleration.y = gravity
#	velocity += acceleration * delta
#	velocity = move_and_slide_with_snap(velocity, -transform.basis.y, Vector3.UP, true)

func _physics_process(delta):
	velocity += gravity
	get_input(delta)
	
	# move_and_slide takes the PRE-DELTA velocity, so don't multiply anything
	# in velocity by delta
	velocity = move_and_slide(velocity, Vector3.UP, true, 4, deg2rad(max_floor_angle_degrees))
	var n_left1 = $Body/Track1/RayCast.get_collision_normal()
	var n_left2 = $Body/Track1/RayCast2.get_collision_normal()
	var n_right1 = $Body/Track2/RayCast.get_collision_normal()
	var n_right2 = $Body/Track2/RayCast2.get_collision_normal()
	var normal = ((n_left1 + n_left2 + n_right1 + n_right2) / 4.0).normalized()
	var normal_dot_up = normal.dot(Vector3.UP)
	var min_dot_limit = cos(deg2rad(max_floor_angle_degrees))
	
	if normal_dot_up > min_dot_limit:
		var xform = align_with_y(Transform(global_transform), normal)
		global_transform = global_transform.interpolate_with(xform, 0.2)

func get_input(delta):
	var vy = velocity.y
	velocity = Vector3.ZERO
	if Input.is_action_pressed("accelerate") or joystick.output.y < 0:
		velocity += -global_transform.basis.z * speed
	if Input.is_action_pressed("reverse") or joystick.output.y > 0:
		velocity += global_transform.basis.z * speed
	if is_joystick_enabled:
		var joystick_y_output = joystick.output.y
		velocity *= abs(joystick_y_output)
		var joystick_x_output = joystick.output.x * -1
		rotate_y(rot_speed * joystick_x_output * delta)
	else:
		if Input.is_action_pressed("ui_right"):
			rotate_y(-rot_speed * delta)
		if Input.is_action_pressed("ui_left"):
			rotate_y(rot_speed * delta)
	velocity.y = vy

#func get_input(delta):
#	#var forward = Input.get_action_strength("accelerate") - Input.get_action_strength("reverse")
#	var right = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
#
#	accel_vel = Vector2.ZERO
#	if Input.is_action_pressed("ui_up"):
#		accel_vel += Vector2.ONE * engine_power
#	if Input.is_action_pressed("ui_down"):
#		accel_vel +=  Vector2.ONE * braking
#
#	accel_vel[0] += engine_power * right
#	accel_vel[1] += engine_power * -right

func apply_friction(delta):
	if velocity.length() < 0.2 and acceleration.length() == 0:
		velocity.x = 0
		velocity.z = 0
	var friction_force = velocity * friction * delta
	var drag_force = velocity * velocity.length() * drag * delta
	acceleration += drag_force + friction_force
#	var friction_wheels = wheel_vel * friction * delta
#	var drag_force_friction = wheel_vel * velocity.length() * drag * delta
#	accel_vel = drag_force_friction + friction_wheels

func calculate_steering(delta):
	wheel_vel += accel_vel * delta
	var x = transform.origin.x
	var y = transform.origin.z
	var diff = wheel_vel[1] - wheel_vel[0]
	var sum = wheel_vel[1] + wheel_vel[0]
	var omega = diff / wheel_base
	
	if abs(diff) < 1e-6:
		var mean_delta = sum/2.0
		var velx = mean_delta * cos(rotation.y) 
		var vely = mean_delta * sin(rotation.y)
		var local_velocity = Vector3(vely, 0, velx)
		velocity = local_velocity
		pass
		print("Moving Forward ", velocity)
		
	elif abs(sum) < 1e-6:
		rotate(transform.basis.y, omega * delta)
		print("Rotating ", transform.basis.y)
	else:
		var R = (sum/diff) * (wheel_base/2.0)
		var ICCx = x - R*sin(rotation.y)
		var ICCy = y + R*cos(rotation.y)	

		var velx = (x-ICCx)*cos(omega*delta) - (y-ICCy)*sin(omega*delta) + ICCx - x
		var vely = (x-ICCx)*sin(omega*delta) + (y-ICCy)*cos(omega*delta) + ICCy - y
		var local_velocity = Vector3(vely, 0, velx)
		velocity += transform * local_velocity

		rotate(transform.basis.y, omega * delta)
#


func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform
