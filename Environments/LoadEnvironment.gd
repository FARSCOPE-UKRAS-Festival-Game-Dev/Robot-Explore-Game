extends Spatial

export (PackedScene) var robotScene


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var robotclone = robotScene.instance()
	var scene_root = get_parent()
	scene_root.add_child(robotclone)
	robotclone.global_transform = $RobotStartLocation.global_transform
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
