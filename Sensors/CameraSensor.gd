extends "BaseSensor.gd"

#Size of the viewport in pixels. Not sure how this will work on different devices 
export var camera_resolution = Vector2(500, 300)

onready var CAMERA_RANGE = 10
onready var raygeom = $CanSeeRayDraw
onready var camgeom = $Body/Viewport/Camera/CameraDraw




# Called when the node enters the scene tree for the first time.
func _ready():
	$Body/Viewport.size = camera_resolution

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#Camera doesn't follow parent's tranform so we set it manually
	$Body/Viewport/Camera.global_transform = $Body/CameraPosition.global_transform

func draw_fullstrum():
	var fullstrum_planes = $Body/Viewport/Camera.get_frustum()
	camgeom = $Body/Viewport/Camera/CameraDraw
	# near, far, left, top, right, bottom
	var near = fullstrum_planes[0]
	var far = fullstrum_planes[1]
	var left = fullstrum_planes[2]
	var top = fullstrum_planes[3]
	var right = fullstrum_planes[4]
	var bottom = fullstrum_planes[5]
	
	var far_point_top_left = far.intersect_3(top,left)
	var far_point_top_right = far.intersect_3(top,right)
	var far_point_bottom_right = far.intersect_3(bottom,right)
	var far_point_bottom_left = far.intersect_3(bottom,left)
	var cam_pos = $Body/CameraPosition.global_transform.origin
	
	far_point_top_left = $Body/Viewport/Camera.to_local(far_point_top_left)
	far_point_top_right = $Body/Viewport/Camera.to_local(far_point_top_right)
	far_point_bottom_right = $Body/Viewport/Camera.to_local(far_point_bottom_right)
	far_point_bottom_left = $Body/Viewport/Camera.to_local(far_point_bottom_left)
	cam_pos = $Body/Viewport/Camera.to_local(cam_pos)
#
#	print("far_point_top_left : ")
#	print(far_point_top_left)
#	print("far_point_top_right : ")
#	print(far_point_top_right)
#
#	print("far_point_bottom_right : ")
#	print(far_point_bottom_right)
#
#	print("far_point_bottom_left : ")
#	print(far_point_bottom_left)

	var fill_texture = ImageTexture.new()
#	var fill = Image.new()
#	fill.lock()
#	fill.fill(Color(255,255,255))
#	fill.unlock()
#	fill_texture.create_from_image(fill)

	camgeom.clear()
#	camgeom.begin(1, null)
#	camgeom.add_vertex(far_point_top_left)
#	camgeom.add_vertex(far_point_top_right)
#
#	camgeom.add_vertex(far_point_top_right)
#	camgeom.add_vertex(far_point_bottom_right)
#
#	camgeom.add_vertex(far_point_bottom_right)
#	camgeom.add_vertex(far_point_bottom_left)
#
#	camgeom.add_vertex(far_point_bottom_left)
#	camgeom.add_vertex(far_point_top_left)
#
#	camgeom.add_vertex(far_point_top_left)
#	camgeom.add_vertex(cam_pos)
##
#	camgeom.add_vertex(far_point_top_right)
#	camgeom.add_vertex(cam_pos)
#
#	camgeom.add_vertex(far_point_bottom_right)
#	camgeom.add_vertex(cam_pos)
#
#	camgeom.add_vertex(far_point_bottom_left)
#	camgeom.add_vertex(cam_pos)
#	camgeom.end()
	
	camgeom.begin(5, null)
	camgeom.add_vertex(cam_pos)
	camgeom.add_vertex(far_point_top_left)
	camgeom.add_vertex(far_point_bottom_left)
	camgeom.add_vertex(cam_pos)
	
	camgeom.add_vertex(cam_pos)
	camgeom.add_vertex(far_point_top_right)
	camgeom.add_vertex(far_point_bottom_right)
	camgeom.add_vertex(cam_pos)
	
	camgeom.end()
	
func render_view():
	#cameras will send what they capture to the nearist viewport in the tree
	#so we make the camera a child of the viewport
	return $Body/Viewport.get_texture()

func can_see(object):
	#works as intented but can't detect 
	var inside = true
	var fullstrum_planes = $Body/Viewport/Camera.get_frustum()
	var point = object.global_transform.origin
	if Globals.camera_trigger_debug:
		print("Checking point within camera fullstrum")
		draw_fullstrum()

	for plane in fullstrum_planes:
		var dot = plane.distance_to(point) 
		if dot < 0:
			continue
		else:
			inside = false

	if inside:
		if Globals.camera_trigger_debug:
			print("Objects center is within viewing fullstum checking raycast...")
		var test_ray = $Body/Viewport/Camera/CanSeeRay
		test_ray.enabled = true
		test_ray.global_transform.origin = $Body/CameraPosition.global_transform.origin
		
		test_ray.cast_to = test_ray.to_local(object.global_transform.origin)
		
		#Vector3(0,0,-CAMERA_RANGE)
		
		test_ray.force_raycast_update()
		if Globals.camera_trigger_debug:
			raygeom.clear()
			raygeom.begin(1, null)
			raygeom.add_vertex(Vector3(0, 0, 0))
			raygeom.add_vertex(test_ray.cast_to)
			raygeom.end()
		else:
			raygeom.clear()
		var detected_object= test_ray.get_collider()
		if detected_object== object:
			inside = true
			
		else:
			inside = false
			
		if Globals.camera_trigger_debug:
			print("Raycast result %s" % inside)
	return inside
			


func _on_Camera_visibility_changed():
	draw_fullstrum()
