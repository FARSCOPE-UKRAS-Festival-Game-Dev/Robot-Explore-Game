extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var progress = $TextureProgress
var sensor_class = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_sensor_class(sclass):
	if is_temp_sensor(sclass):
		sensor_class = sclass
		progress.min_value = sensor_class.TEMPERATURE_LIMITS[0]
		progress.max_value = sensor_class.TEMPERATURE_LIMITS[1]

func is_temp_sensor(sc):
	return sc != null and sc.has_method('get_temperature')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_temp_sensor(sensor_class):
		progress.value = sensor_class.get_temperature()
		
		

