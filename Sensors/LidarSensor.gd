extends "BaseSensor.gd"

export var lidar_resolution = Vector2(400,500)
var rotation_speed = 90.0 # The angular speed (degrees/s)
var angle_range = 45.0 #The maximum deviation from forward dir that will get readings (degrees)
var poll_rate = 3.0 #distance reads per second (Hz)
var noise = 1.5 # standard deviation of distance read noise- (make % based?)
var max_range = 50 # maximum range of lidar

func scanning():
	var ray = $LidarBody/Head/RayCast
	#print($LidarBody/Head.rotation_degrees)
	#ray.cast_to = Vector3(randi()*1000,randi()*1000,randi()*1000)
	ray.force_raycast_update()
	if ray.is_colliding():
		var hit = ray.get_collision_point()
		print(hit)

func _ready():
	$Viewport.size=lidar_resolution
	$LidarPlot.flip_v = true
	var location= $LidarBody/Head.global_transform.origin
	print(location)
	

func _process(delta):
	$LidarBody/Head.rotate_y(deg2rad(rotation_speed)*delta)
	$LidarBody/Head/RayCast.rotate_x(deg2rad(rotation_speed)*delta)
	scanning()
	
	#print($LidarBody/Head.rotation)


func _render_view():
	return $Viewport.get_texture()
	




