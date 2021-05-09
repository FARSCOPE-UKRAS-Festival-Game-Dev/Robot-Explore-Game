extends Spatial



# Called when the node enters the scene tree for the first time.
func _ready():
	#Get the viewport texture to display it to the GUI, we only need to do this once for viewports
	$Sensor_HUD.set_render_target($Robot/CameraSensor/CameraBody/Viewport.get_texture())


