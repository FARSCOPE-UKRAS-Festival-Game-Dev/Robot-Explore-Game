extends Spatial

# Called when the node enters the scene tree for the first time.
func _ready():
	#Get the viewport texture to display it to the GUI, we only need to do this once for viewports
	$Robot_with_sensor/ControlPanel.queue_free()
	$ControlPanel.set_sensor_classes([$Robot_with_sensor/Robot/Lidar,$SideView,$TopView])
	$ControlPanel.set_sensor_descriptions(["Lidar View","Side View","Top View"])
	

