extends "BaseSensor.gd"
# occupancy map
export var lidar_resolution = Vector2(300,300) # pixel used to show occupancy map
# create texture required to show occupancy mao
var texture = ImageTexture.new()
var occupancy_map = Image.new()

export var grid_val=0.1 #each grid is 0.01
export var rotation_speed = 90.0 # The angular speed (degrees/s) of the ray

export var max_range = 500 # maximum range of lidar

var hit_location
var head_location
var counter =0
var pixel_draw = Vector2(0,0)
#middle pixel assigned to robot
var sensor_pixel= Vector2(round(lidar_resolution.x/2),round(lidar_resolution.y/2));
#raycast
onready var ray = $LidarBody/RayCast
# laser vector in its local frame
var point_laser=Vector3(max_range,0,0)

#the following still need to be implemented
var angle_range = 45.0 #The maximum deviation from forward dir that will get readings (degrees)
var poll_rate = 3.0 #distance reads per second (Hz)
var noise = 1.5 # standard deviation of distance read noise- (make % based?)

func scanning():
	# update raycast
	ray.force_raycast_update()
	#check for collision
	var flag= ray.is_colliding()
	var hit=[]
	# in case of collision get collision point
	if flag:
		hit=ray.get_collision_point()
		#useful for debugging
		#print(ray.get_collider().name)
	return [flag,hit]

func _ready():
	$Viewport.size = lidar_resolution

	# create occupancy map, each pixel can be linked to a value of distance
	occupancy_map.create(lidar_resolution.x,lidar_resolution.y, false, Image.FORMAT_RGBA8)
	occupancy_map.fill(Color(1,1,1,1))
	# set middle pixel to red colour representing robot
	occupancy_map.lock()
	occupancy_map.set_pixel(sensor_pixel.x,sensor_pixel.y,Color(1,0,0,1))
	occupancy_map.unlock()

	$Viewport/LidarPlot.flip_v = true
	head_location= $LidarBody/Head.global_transform.origin

func _process(delta):
	#rotation of lidar ray
	$LidarBody/RayCast.rotate_y(deg2rad(rotation_speed)*delta)
	#get location of head which coincides with laser origin
	head_location= $LidarBody/Head.global_transform.origin
	#get value of total amount of rotation so far
	counter=counter+rotation_speed*delta
	# draw ray 
	$LidarBody/RayCast/ImmediateGeometry.clear()
	$LidarBody/RayCast/ImmediateGeometry.begin(1, null) #
	$LidarBody/RayCast/ImmediateGeometry.add_vertex(ray.global_transform.origin)
	$LidarBody/RayCast/ImmediateGeometry.add_vertex(ray.global_transform.origin+ to_global(ray.cast_to))
	$LidarBody/RayCast/ImmediateGeometry.end() #
	#check lidar collision data
	hit_location = scanning()
	# in case there is a collision compute the pixel location in occupancy map
	if hit_location[0]:
		var laserVec = hit_location[1] - head_location
		#compute pixel location: middle pixel + mag in x-z plane*unit vector in that plane 
		#and divided by value of each pixek
		pixel_draw= (sensor_pixel+ (Vector2(hit_location[1].x,hit_location[1].z).length()/grid_val)*Vector2(hit_location[1].x,hit_location[1].z).normalized()).round()
		#draw collision points as black dots
		occupancy_map.lock()
		occupancy_map.set_pixel(pixel_draw.x,pixel_draw.y,Color(0,0,0,1))
		occupancy_map.unlock()

	#once whole rotation is done clear counter and occupancy map
	if counter>=360:
		counter=0;
		occupancy_map.fill(Color(1,1,1,1))
	# set middle pixel to red colour
		occupancy_map.lock()
		occupancy_map.set_pixel(sensor_pixel.x,sensor_pixel.y,Color(1,0,0,1))
		occupancy_map.unlock()
	# check when one resolution has been made
	
	# set the texture to the computed occupancy map
	texture.create_from_image(occupancy_map)
	$Viewport/LidarPlot.texture = texture
	
func render_view():
	return $Viewport/LidarPlot.get_texture()
	




