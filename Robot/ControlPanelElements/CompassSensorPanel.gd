extends Control

onready var coordinates = $Control/Coordinates
var sensor_class = null

var enabled = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_sensor_class(sclass):
	sensor_class = sclass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if sensor_class != null and enabled:
		var rot = sensor_class.get_rotation()
		# range [0, 1]
		coordinates.material.set_shader_param("pos", rot)
	
