extends Spatial
enum robot_action {
	NONE,
	TAKING_PICTURE,
	DRILL_SAMPLE,
	COLLECT_SAMPLE,
} 

signal doing_action
onready var viewing_camera = $Robot/ForwardCameraSensor/Body/Viewport/Camera
onready var body =  $Robot/ForwardCameraSensor/Body/

func _ready():
	#Get the viewport texture to display it to the GUI, we only need to do this once for viewports
	$ControlPanel.set_sensor_classes({
		'camera': $Robot/ForwardCameraSensor,
		'lidar': $Robot/Lidar,
		'templeft': $Robot/TempLeft,
		'tempright': $Robot/TempRight,
		'whisker': $Robot/WhiskerSensor
	})
	
	$ControlPanel.special_menu.connect("drill_button_pressed",self,"drill_sample")
	$ControlPanel.special_menu.connect("take_picture_button_pressed",self,"take_picture")
	$ControlPanel.special_menu.connect("collect_sample_button_pressed",self,"collect_sample")



func take_picture():
	#play sound
	emit_signal("doing_action",robot_action.TAKING_PICTURE)

func drill_sample():
	#play sound
	emit_signal("doing_action",robot_action.DRILL_SAMPLE)

func collect_sample():
	#play sound
	emit_signal("doing_action",robot_action.COLLECT_SAMPLE)

