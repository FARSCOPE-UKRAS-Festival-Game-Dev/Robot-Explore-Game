extends "BaseSensor.gd"

#Size of the viewport in pixels. Not sure how this will work on different devices 
export var camera_resolution = Vector2(400,500)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$CameraBody/Viewport.size = camera_resolution


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Camera doesn't follow parent's tranform so we set it manually
	$CameraBody/Viewport/Camera.global_transform = $CameraBody.global_transform
	$CameraBody/Viewport/Camera.translate_object_local (Vector3(0,1,0))
	$CameraBody/Viewport/Camera.rotate_object_local(Vector3(0, 1, 0),-PI/2) #I don't know why it's this angle 
func _render_view():
	#cameras will send what they capture to the nearist viewport in the tree
	#so we make the camera a child of the viewport
	return $CameraBody/Viewport.get_texture()
