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
	$ControlPanel.set_sensor_classes({
		'camera': $Robot/ForwardCameraSensor,
		'lidar': $Robot/Lidar,
		'templeft': $Robot/TempLeft,
		'tempright': $Robot/TempRight,
		'whisker': $Robot/WhiskerSensor
	})
	
	$ControlPanel.SpecialMenu.connect("drill_button_pressed",self,"drill_sample")
	$ControlPanel.SpecialMenu.connect("take_picture_button_pressed",self,"take_picture")


func take_picture():
	#play sound
	emit_signal("doing_action",robot_action.TAKING_PICTURE)

func drill_sample():
	#play sound
	emit_signal("doing_action",robot_action.DRILL_SAMPLE)

