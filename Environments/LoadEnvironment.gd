extends Spatial

export (PackedScene) var robotScene
export(String) var dialog_file = "res://Assets/Dialog/DefaultDialog.json"
onready var globals = get_node('/root/Globals')
signal finished_loading
# Called when the node enters the scene tree for the first time.
func _ready():
	print("Loading dialog from: %s " % dialog_file)
	Globals.load_dialog_from_file(dialog_file)

	var robotclone = robotScene.instance()
	globals.robot = robotclone
	var scene_root = get_parent()
	scene_root.add_child(robotclone)
	
#	var overlay_panel = globals.control_panel_ui
#	scene_root.move_child(robotclone)


	robotclone.global_transform = $RobotStartLocation.global_transform
	emit_signal("finished_loading")

