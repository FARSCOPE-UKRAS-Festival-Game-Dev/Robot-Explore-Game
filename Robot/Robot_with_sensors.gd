extends Spatial



# Called when the node enters the scene tree for the first time.
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
	
func recieve_dialog(text):
	$ControlPanel._on_recieve_dialog(text)
