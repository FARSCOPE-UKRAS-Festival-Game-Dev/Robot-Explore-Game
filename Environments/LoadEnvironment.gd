extends Spatial

export (PackedScene) var robotScene

onready var globals = get_node('/root/Globals')
signal finished_loading
# Called when the node enters the scene tree for the first time.
func _ready():
	var robotclone = robotScene.instance()
	globals.robot = robotclone
	var scene_root = get_parent()
	scene_root.add_child(robotclone)
	robotclone.global_transform = $RobotStartLocation.global_transform
	emit_signal("finished_loading")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


