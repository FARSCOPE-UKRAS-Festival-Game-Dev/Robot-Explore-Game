extends Node


#### Options
var debug_mode = true

##### Control Interface
var control_panel_ui_scene_pl = preload('res://Utilities/Control_Panel_UI.tscn')
var control_panel_loaded = false
var is_joystick_enabled = true

var control_panel_ui
var joystick
var book_overlay
var dialog_popup
var objective_popup
#####
var dialog_JSON_data
# Called when the node enters the scene tree for the first time.
func _ready():
	load_dialog_from_file()

func load_dialog_from_file():
	var file = File.new()
	file.open("res://Dialog/dialog_JSON.json", File.READ)
	dialog_JSON_data =  parse_json(file.get_as_text())
	
func init_control_panel():
	if not control_panel_loaded:
		
		var root = get_tree().get_root()
		
		control_panel_ui = control_panel_ui_scene_pl.instance()
		root.add_child(control_panel_ui)
		
		joystick = control_panel_ui.get_node('Joystick')
		if not OS.has_touchscreen_ui_hint() and joystick.visibility_mode == joystick.VisibilityMode.TOUCHSCREEN_ONLY:
			is_joystick_enabled = false
		
		book_overlay = control_panel_ui.get_node('BookOverlay')
		set_book_visible(false)
		
		dialog_popup = control_panel_ui.get_node('DialogPopup')
		
		
		objective_popup = control_panel_ui.get_node("ObjectivePopup")
		
		for mission_node in get_tree().get_nodes_in_group("Missions"):
			for objective in mission_node.objective_list:
				objective.connect("on_objective_complete",self,"show_objective_complete_popup")
		
		control_panel_loaded = true
func set_book_visible(value):
	
	book_overlay.visible = value
	joystick.enabled = !value
	 
func queue_dialog(dialog_key):
	assert(dialog_JSON_data.has(dialog_key),"ERROR - dialog key: \"%s\" not in JSON file" % dialog_key)
	
	var dialog_data = dialog_JSON_data[dialog_key]
	dialog_popup.queue_text(dialog_data["dialog"])
	print(dialog_data)
	if dialog_data.has("next_dialog"):
		queue_dialog(dialog_data["next_dialog"])
		print("queue")
func show_objective_complete_popup(objective):
	objective_popup.display_text("Objective Complete - "+objective.display_text)
	

