extends "BaseSensor.gd"
# occupancy map
export var lidar_resolution = Vector2(300,300) # pixel used to show occupancy map
# create texture required to show occupancy mao
var texture = ImageTexture.new()
var occupancy_map = Image.new()

export var grid_val = 0.1 #each grid is 0.01
export var rotation_speed = 180.0 # The angular speed (degrees/s) of the ray

export var max_range = 500 # maximum range of lidar
var point_laser = Vector3(max_range,0,0)

export var field_of_view = 90 # how many degrees in front will the sensor see?

var hit_locations: Array
var head_location
var counter = 0
var counter_direction = 1;
var pixel_draw = Vector2(0,0)

# List of pixels drawn on the LIDAR screen
var drawn_pixel_locations: Array = []
var last_num_of_frames: int = INF
var frames_this_sweep: int = 0

# middle pixel assigned to robot
var sensor_pixel= Vector2(round(lidar_resolution.x/2),round(lidar_resolution.y * 9.0 / 10.0));
onready var head = $LidarBody/Head
# raycast
onready var rays = $LidarBody/Head/RayCasts
onready var raygeom = $LidarBody/Head/RayCasts/RayCast/ImmediateGeometry
onready var robot_sprite: Image = load("res://Assets/Images/lidar_robot_sprite.png").get_data()
onready var fov_cone: Image = load("res://Assets/Images/lidar_fov_cone.png").get_data()

func scanning(ray: RayCast):
	# update raycast
	ray.force_raycast_update()
	# check for collision
	var flag= ray.is_colliding()
	var hit=[]
	# in case of collision get collision point
	if flag:
		hit=ray.get_collision_point()
		# useful for debugging
		#print(ray.get_collider().name)
	return [flag,hit]

func _ready():
	$Viewport.size = lidar_resolution
	
	# Resize images
	var robot_sprite_initial_size = robot_sprite.get_size()
	robot_sprite.resize(robot_sprite_initial_size.x * 2, robot_sprite_initial_size.y * 2, 0)
	
	# create occupancy map, each pixel can be linked to a value of distance
	occupancy_map.create(lidar_resolution.x,lidar_resolution.y, false, Image.FORMAT_RGBA8)
	# set the texture to the computed occupancy map
	texture.create_from_image(occupancy_map)
	$Viewport/LidarPlot.texture = texture
	reset_lidar_background()

	$Viewport/LidarPlot.flip_v = true
	head_location = $LidarBody/Head.global_transform.origin
	
func _process(delta):
	# draw ray relative to sensor location
	raygeom.clear()
	raygeom.begin(1, null)
	raygeom.add_vertex(Vector3(0, 0, 0))
	raygeom.add_vertex(rays.get_children()[0].cast_to)
	raygeom.end()
	
	#once whole rotation is done clear counter and occupancy map
	if counter >= int(field_of_view * 3/2):
		counter = int(field_of_view / 2)
		last_num_of_frames = frames_this_sweep
		frames_this_sweep = 0
		#counter_direction = -1
		#reset_lidar_background()
	elif counter < int(field_of_view / 2):
		#counter_direction = 1
		#reset_lidar_background()
		pass
	# check when one resolution has been made
	texture.create_from_image(occupancy_map)
	$Viewport/LidarPlot.texture = texture
	
	for i in len(hit_locations):
		if hit_locations[i][0]:
			head_location = $LidarBody/Head.global_transform.origin
			var local_forward = global_transform.basis * Vector3.FORWARD
			var global_forward = Vector3.FORWARD
			var angle = Vector2(global_forward.x, global_forward.z).angle_to(Vector2(local_forward.x, local_forward.z))
			var laserVec: Vector3 = hit_locations[i][1] - head_location
			laserVec = laserVec.rotated(Vector3.UP, angle)
			# compute pixel location: middle pixel + mag in x-z plane*unit vector in that plane 
			# and divided by value of each pixek
			pixel_draw = (sensor_pixel+ (Vector2(laserVec.x, laserVec.z).length()/grid_val) * Vector2(laserVec.x, laserVec.z).normalized()).round()
			# draw collision points as black dots
			draw_pixels(pixel_draw)
			drawn_pixel_locations.append(pixel_draw)
			if len(drawn_pixel_locations) > last_num_of_frames * len(hit_locations) * 0.65:
				clear_pixels(drawn_pixel_locations.pop_front())
	occupancy_map.blend_rect(fov_cone, Rect2(Vector2(0,0), fov_cone.get_size()), sensor_pixel - Vector2(7,0) - ((fov_cone.get_size() / 2.0)))
	occupancy_map.blend_rect(robot_sprite, Rect2(Vector2(0,0), robot_sprite.get_size()), sensor_pixel - Vector2(robot_sprite.get_width()/2, 0))
	hit_locations.clear()
	frames_this_sweep += 1


func _physics_process(delta):
	# rotation of lidar ray
	#ray.set_cast_to(point_laser.rotated(Vector3(0,1,0),deg2rad(counter)))
	rays.rotation.y = 0
	rays.rotate(Vector3(0,1,0), -deg2rad(counter))
	
	# get value of total amount of rotation so far
	counter = counter + counter_direction * rotation_speed * delta
	
	var raycasts = rays.get_children()
	for i in len (raycasts):
		if raycasts[i] is RayCast:
			hit_locations.append(scanning(raycasts[i]))
	# check lidar collision data
	# in case there is a collision compute the pixel location in occupancy map


# Method to draw a dot at a certain point on the image
func draw_pixels(position: Vector2):
	var size = occupancy_map.get_size()
	occupancy_map.lock()
	for x in range(3):
		for y in range(3):
			var pixel_pos = Vector2(position.x - 1 + x, position.y - 1 + y)
			if pixel_pos.x < size.x and pixel_pos.x >= 0\
					and pixel_pos.y < size.y and pixel_pos.y >= 0:
				var greenness = 1.0 - (0.4 * abs(1 - x)) - (0.4 * (abs(1 - y)))
				occupancy_map.set_pixel(pixel_pos.x, pixel_pos.y, Color(0,greenness,0,1))
	occupancy_map.unlock()


# Method to clear a dot at a certain point on the image
func clear_pixels(position: Vector2):
	var size = occupancy_map.get_size()
	occupancy_map.lock()
	for x in range(3):
		for y in range(3):
			var pixel_pos = Vector2(position.x - 1 + x, position.y - 1 + y)
			if pixel_pos.x < size.x and pixel_pos.x >= 0\
					and pixel_pos.y < size.y and pixel_pos.y >= 0:
				occupancy_map.set_pixel(pixel_pos.x, pixel_pos.y, Color(0,0,0,1))
	occupancy_map.unlock()


# Reset the LIDAR image background
func reset_lidar_background():
	occupancy_map.fill(Color(0,0,0,1))
	# set middle pixel to red colour
	occupancy_map.lock()
	occupancy_map.set_pixel(sensor_pixel.x,sensor_pixel.y,Color(1,0,0,1))
	occupancy_map.unlock()
	
	occupancy_map.blend_rect(fov_cone, Rect2(Vector2(0,0), fov_cone.get_size()), sensor_pixel - Vector2(7,0) - ((fov_cone.get_size() / 2.0)))
	occupancy_map.blend_rect(robot_sprite, Rect2(Vector2(0,0), robot_sprite.get_size()), sensor_pixel - Vector2(robot_sprite.get_width()/2, 0))


func render_view():
	return $Viewport/LidarPlot.get_texture()
