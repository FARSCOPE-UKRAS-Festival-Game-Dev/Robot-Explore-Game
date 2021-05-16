extends "res://Sensors/BaseSensor.gd"
# occupancy map
export var lidar_resolution = Vector2(300,300)
var texture = ImageTexture.new()
var occupancy_map = Image.new()

var grid_val=0.1 #each grid is 0.01
var rotation_speed = 90.0 # The angular speed (degrees/s)
var angle_range = 45.0 #The maximum deviation from forward dir that will get readings (degrees)
var poll_rate = 3.0 #distance reads per second (Hz)
var noise = 1.5 # standard deviation of distance read noise- (make % based?)
var max_range = 500 # maximum range of lidar
var hit_location
var head_location
var counter =0
var pixel_draw = Vector2(0,0)
var sensor_pixel= Vector2(round(lidar_resolution.x/2),round(lidar_resolution.y/2));
#onready var ray = $LidarBody/Head/RayCast
onready var ray = $LidarBody/RayCast
#var point_laser=Vector3(0,0,max_range)
#var point_laser=Vector3(0,max_range,0)
var point_laser=Vector3(max_range,0,0)
func scanning():
	#var ray = $LidarBody/Head/RayCast
	#print($LidarBody/Head.rotation_degrees)
	#ray.cast_to = Vector3(randi()*1000,randi()*1000,randi()*1000)
	ray.force_raycast_update()
	var flag= ray.is_colliding()
	#rint(flag)
	var hit=[]
	if flag:
		hit=ray.get_collision_point()
		print(ray.get_collider().name)
	#print([flag,hit])
	return [flag,hit]

func _ready():
	$Viewport.size=lidar_resolution
	occupancy_map.create(lidar_resolution.x,lidar_resolution.y, false, Image.FORMAT_RGBA8)
	occupancy_map.fill(Color(1,1,1,1))
	# set middle pixel to red colour
	occupancy_map.lock()
	occupancy_map.set_pixel(sensor_pixel.x,sensor_pixel.y,Color(1,0,0,1))
	occupancy_map.unlock()

	$Viewport/LidarPlot.flip_v = true
	head_location= $LidarBody/Head.global_transform.origin


	

func _process(delta):
	#$LidarBody/Head.rotate_y(deg2rad(rotation_speed)*delta)
	$LidarBody/RayCast.rotate_y(deg2rad(rotation_speed)*delta)
	head_location= $LidarBody/Head.global_transform.origin
	#print($LidarBody/Head.global_transform.basis)
	#print(ray.global_transform.basis)
	#print(ray.cast_to)
	counter=counter+rotation_speed*delta
	#ray.set_cast_to(point_laser.rotated(Vector3(0,0,1),deg2rad(counter)))
	#ray.set_cast_to(point_laser.rotated(Vector3(1,0,0),deg2rad(counter)))
	#ray.set_cast_to(point_laser.rotated(Vector3(0,1,0),deg2rad(counter)))
	#print(ray.cast_to)
	$LidarBody/RayCast/ImmediateGeometry.clear()
	$LidarBody/RayCast/ImmediateGeometry.begin(1, null) #
	$LidarBody/RayCast/ImmediateGeometry.add_vertex(ray.global_transform.origin)
	$LidarBody/RayCast/ImmediateGeometry.add_vertex(ray.global_transform.origin+ to_global(ray.cast_to))
	$LidarBody/RayCast/ImmediateGeometry.end() #
	#print(ray.global_transform.basis)
	#print($LidarBody/Head.global_transform.basis)
	#print($LidarBody/Base.global_transform.basis)
	hit_location = scanning()
	if hit_location[0]:
		var laserVec = hit_location[1] - head_location
		print(hit_location[1])
		#comput pixel location
		pixel_draw= (sensor_pixel+ (hit_location[1].length()/grid_val)*Vector2(hit_location[1].x,hit_location[1].z).normalized()).round()
		print(pixel_draw)
		#pixel_draw=round(pixel_draw)
		occupancy_map.lock()
		occupancy_map.set_pixel(pixel_draw.x,pixel_draw.y,Color(0,0,0,1))
		occupancy_map.unlock()
	#occupancy_map.fill(Color(0,randf(),0,1))	

	

	

	if counter>=360:
		counter=0;
	#	occupancy_map.fill(Color(1,1,1,1))
	# set middle pixel to red colour
		occupancy_map.lock()
		occupancy_map.set_pixel(sensor_pixel.x,sensor_pixel.y,Color(1,0,0,1))
		occupancy_map.unlock()
	# check when one resolution has been made
	
	texture.create_from_image(occupancy_map)
	$Viewport/LidarPlot.set_texture(texture)
	#$lidarOcc.set_texture(texture)
	#print($LidarBody/Head.rotation)



func render_view():
	#return $lidarOcc.get_texture()
	return $Viewport.get_texture()
	




