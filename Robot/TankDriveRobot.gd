extends KinematicBody


export var gravity = Vector3.UP * -4
export var speed = 2
export var rot_speed = 0.60
export var max_floor_angle_degrees = 30

# Car state properties
var velocity = Vector3.ZERO  # current velocity

var joystick
var is_joystick_enabled: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	joystick = Globals.joystick
	is_joystick_enabled = Globals.is_joystick_enabled
	set_camera_enable()
	Globals.connect("options_updated",self,"set_camera_enable")
func set_camera_enable():
	if Globals.debug_mode:
		$CameraBase/Camera.make_current()  
	else:
		$CameraBase/Camera.clear_current()
func _physics_process(delta):
	velocity += gravity
	get_input(delta)
	
	# move_and_slide takes the PRE-DELTA velocity, so don't multiply anything
	# in velocity by delta
	velocity = move_and_slide(velocity, Vector3.UP, true, 4, deg2rad(max_floor_angle_degrees))
	
	# Align robot with ground
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


func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform
