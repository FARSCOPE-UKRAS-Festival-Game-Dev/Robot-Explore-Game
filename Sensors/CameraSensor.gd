extends "BaseSensor.gd"

#Size of the viewport in pixels. Not sure how this will work on different devices 
export var camera_resolution = Vector2(500, 300)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Body/Viewport.size = camera_resolution

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	#Camera doesn't follow parent's tranform so we set it manually
	$Body/Viewport/Camera.global_transform = $Body/CameraPosition.global_transform
	
func render_view():
	#cameras will send what they capture to the nearist viewport in the tree
	#so we make the camera a child of the viewport
	return $Body/Viewport.get_texture()
