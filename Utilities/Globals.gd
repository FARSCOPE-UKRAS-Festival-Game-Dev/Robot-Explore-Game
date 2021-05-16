extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var control_panel_ui_scene_pl = preload('res://Utilities/Control_Panel_UI.tscn')
var joystick_loaded = false
var is_joystick_enabled = true
var joystick

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func show_joystick():
	if not joystick_loaded:
		var root = get_tree().get_root()
		var control_panel_ui = control_panel_ui_scene_pl.instance()
		root.add_child(control_panel_ui)
		joystick = control_panel_ui.get_node('Joystick')
		joystick_loaded = true
		if not OS.has_touchscreen_ui_hint() and joystick.visibility_mode == joystick.VisibilityMode.TOUCHSCREEN_ONLY:
			is_joystick_enabled = false
