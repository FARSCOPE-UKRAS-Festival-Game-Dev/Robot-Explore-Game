extends Spatial

# Called when the node enters the scene tree for the first time.
func _ready():
	#Get the viewport texture to display it to the GUI, we only need to do this once for viewports
	$TankRobot_with_sensors/ControlPanel.queue_free()
	
	$ControlPanel.set_sensor_classes([$TankRobot_with_sensors/Robot/Lidar,$TopView])
	$ControlPanel.set_sensor_descriptions(["Lidar View","Top View"])
	

