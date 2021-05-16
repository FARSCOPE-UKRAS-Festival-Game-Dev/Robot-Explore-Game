extends Spatial

export (PackedScene) var robotScene

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	var robotclone = robotScene.instance()
	var scene_root = get_parent()
	scene_root.add_child(robotclone)
	
	robotclone.global_transform = self.global_transform
	#var camera = robotclone.get_node('Robot').get_node('CameraBase').get_node('Camera')
	#print(get_viewport().get_camera())
	#camera.make_current()
	#print(get_viewport().get_camera())
	#print(camera)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
