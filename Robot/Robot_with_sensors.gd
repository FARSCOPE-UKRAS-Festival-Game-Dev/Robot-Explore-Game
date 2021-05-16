extends Spatial



# Called when the node enters the scene tree for the first time.
func _ready():
	#Get the viewport texture to display it to the GUI, we only need to do this once for viewports
	$ControlPanel.set_camera_render_target($Robot/CameraSensor.render_view())
	$ControlPanel.set_whisker_render_target($Robot/WhiskerSensor.render_view())
