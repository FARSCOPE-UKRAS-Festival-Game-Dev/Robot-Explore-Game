extends Spatial

export (PackedScene) var robotScene

onready var globals = get_node('/root/Globals')

# Called when the node enters the scene tree for the first time.
func _ready():
	var robotclone = robotScene.instance()
	var scene_root = get_parent()
	scene_root.add_child(robotclone)
	robotclone.global_transform = $RobotStartLocation.global_transform	
	globals.robot = robotclone
