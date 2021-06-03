extends Spatial
enum robot_action {
	NONE,
	TAKING_PICTURE,
	DRILL_SAMPLE,
} 

signal doing_action

onready var viewing_camera = $Robot/ForwardCameraSensor/Body/Viewport/Camera

func _ready():
	#Get the viewport texture to display it to the GUI, we only need to do this once for viewports
	$ControlPanel.set_sensor_classes([$Robot/ForwardCameraSensor, $Robot/Lidar, $Robot/TempLeft, $Robot/TempRight, $Robot/WhiskerSensor])
	$ControlPanel.set_sensor_descriptions([
		'Camera',
		'LIDAR',
		'',
		'',
		'Whisker',
	])
	



func take_picture():
	#play sound
	emit_signal("doing_action",robot_action.TAKING_PICTURE)

func drill_sample():
	#play sound
	emit_signal("doing_action",robot_action.DRILL_SAMPLE)

