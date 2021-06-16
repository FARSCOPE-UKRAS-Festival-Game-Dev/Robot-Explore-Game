extends "BaseSensor.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
# returns a number between 0 and 1 that represents the offset for the compass
func get_rotation():
	var local_forward = global_transform.basis * Vector3.FORWARD
	var global_forward = Vector3.FORWARD
	var angle = Vector2(global_forward.x, global_forward.z).angle_to(Vector2(local_forward.x, local_forward.z))
	return (angle + PI) / (2 * PI)
