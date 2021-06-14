extends Spatial
enum robot_action {
	NONE,
	TAKING_PICTURE,
	DRILL_SAMPLE,
	COLLECT_SAMPLE,
} 

signal doing_action
signal action_success
signal action_failed

const ACTION_SUCCESS_TIMEOUT = 0.1
onready var success_timeout_timer = $SuccessActionTimeout
var success_flag = false
	
onready var viewing_camera = $Robot/ForwardCameraSensor/Body/Viewport/Camera
onready var body =  $Robot/ForwardCameraSensor/Body/

func _ready():
	#Get the viewport texture to display it to the GUI, we only need to do this once for viewports
	$ControlPanel.set_sensor_classes({
		'camera': $Robot/ForwardCameraSensor,
		'lidar': $Robot/Lidar,
		'templeft': $Robot/TempLeft,
		'tempright': $Robot/TempRight,
		'whisker': $Robot/WhiskerSensor,
		'compass': $Robot/CompassSensor
	})
	
	$ControlPanel.special_menu.connect("drill_button_pressed",self,"drill_sample")
	$ControlPanel.special_menu.connect("take_picture_button_pressed",self,"take_picture")
	$ControlPanel.special_menu.connect("collect_sample_button_pressed",self,"collect_sample")
	


func take_picture():
	#play sound
	do_action(robot_action.TAKING_PICTURE)
func drill_sample():
	#play sound
	do_action(robot_action.DRILL_SAMPLE)

func collect_sample():
	#play sound
	do_action(robot_action.COLLECT_SAMPLE)

func do_action(action):
	
	#Emit signal for action, wait timout seconds to see if we trigger anything if not we fail.
	#timeout could be replaced by animation length or use the animation finished signal
	success_timeout_timer.wait_time = ACTION_SUCCESS_TIMEOUT
	success_flag = false
	emit_signal("doing_action",action)
	success_timeout_timer.start()
	yield(success_timeout_timer,"timeout")
	if success_flag:
		successful_action(action)
	else:
		fail_action(action)
func fail_action(action):
	#print("action: %s didn't do anything" % action)
	emit_signal("action_failed",action)
func successful_action(action):
	emit_signal("action_success",action)
	match action:
		robot_action.TAKING_PICTURE:
			print("Took picture successfully!")
		robot_action.DRILL_SAMPLE:
			print("Drilled sample successfully!")
		robot_action.COLLECT_SAMPLE:
			print("Collected sample successfully!")
			
func on_action_activated_trigger(action,trigger):
	success_flag = true
