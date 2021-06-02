extends Control


onready var overlay_tabs = $OverlayTabs


onready var mission_vbox = overlay_tabs.get_node("PanelContainer/MarginContainer/TabContainer/Mission/ScrollContainer/MissionVBox")
onready var journal_vbox = overlay_tabs.get_node("PanelContainer/MarginContainer/TabContainer/Journal/ScrollContainer/JournalVBox")

var mission_ui = preload("res://Utilities/Overlays/BookElements/MissionItem.tscn")
var log_entry = preload("res://Utilities/Overlays/BookElements/LogEntry.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	populate_missions()

func populate_missions():
	for dummy_mission in mission_vbox.get_children():
		dummy_mission.queue_free()
	for mission_node in get_tree().get_nodes_in_group("Missions"):
		var mission_display = mission_ui.instance()
		mission_vbox.add_child(mission_display)
		mission_display.set_name(mission_node.mission_name)
		mission_display.set_description(mission_node.mission_desc)
		mission_display.set_sub_objectives(mission_node.objective_list)
		for objective in mission_node.objective_list:
			var objective_label = mission_display.objective_labels[objective.id]
			objective_label.update_visibility(objective.enabled)
			objective.connect("on_display_text_set",objective_label,"update_display_text")
			objective.connect("on_objective_complete",objective_label,"mark_complete")
			objective.connect("enable_changed",objective_label,"update_visibility")
			
		mission_node.connect("mission_completed",mission_display,"on_mission_complete")



