extends "res://Scripting/MissionSystem/MultiObjective.gd"

export(int) var plant_dialog_set = null
const NUM_DIALOG_SETS = 3

export(NodePath) var plant_object = null
enum PlantType {
	A,
	B,
	C,
	D,
	E
} 
const enum_to_letter = ["A","B","C","D","E"]
export(PlantType) var plant_type = PlantType.A
var plant_group = null

var plant_type_photoed = false
var plant_type_sampled = false



onready var photo_objective = get_node("ObjectivePhoto")
onready var sample_objective = get_node("ObjectiveSample")
onready var whisker_objective = get_node("ObjectiveWhisker")
onready var hint_action = $NextActionHint
onready var hint_already_done = $AlreadyDoneHint
func is_plant_group_complete():
	return plant_type_photoed and plant_type_sampled

func set_hint(hint_key):
	print("hint key set to %s" % hint_key)
	hint_action.set_first_hint_dialog_key(hint_key)
func set_enable(value):
	.set_enable(value)
	photo_objective.enabled = false
	sample_objective.enabled = false
	
func _ready():
	hint_action.enabled = false
	if plant_object == null:
		plant_object = "Plant"
		if get_node_or_null(plant_object) == null:
			print("%s plant objective as no plant object" % name)
		else:
			plant_object = "../../Plant"
	whisker_objective.get_node("Trigger").must_whisker = plant_object
	whisker_objective.get_node("Trigger").must_whisker_enable = true
	init_dialog()
	plant_group  = "flora_mission_plant_grp_%d" % plant_type
	add_to_group(plant_group)
	
func init_dialog():
	if plant_dialog_set == null:
		plant_dialog_set = randi()%NUM_DIALOG_SETS + 1
		
	photo_objective.on_complete_dialogue = "mission_fauna_got_photo%d" % plant_dialog_set
	sample_objective.on_complete_dialogue = "mission_fauna_got_sample%d" % plant_dialog_set
	whisker_objective.on_complete_dialogue = "mission_fauna_got_whiskers%d" % plant_dialog_set
	

	on_complete_dialogue = "mission_fauna_completed_plant%s" % enum_to_letter[plant_type]
func update_dialog():
	

	if not plant_type_photoed and not plant_type_sampled and whisker_objective.complete:
		set_hint("mission_fauna_need_photo_sample1")
	elif not plant_type_photoed and plant_type_sampled and whisker_objective.complete:
		set_hint("mission_fauna_just_need_photo1")
	elif plant_type_photoed and not plant_type_sampled and whisker_objective.complete:
		set_hint("mission_fauna_just_need_sample1")
	elif not plant_type_photoed and not sample_objective.complete and not whisker_objective.complete:
		print("not complete")
	
	if (whisker_objective.complete and is_plant_group_complete() == false):
		hint_action.enabled = true
	print("node status: ")
	print("Whiskered : %s"% whisker_objective.complete)
	print("Photo enabled : %s"% photo_objective.complete)
	print("Sampled enabled : %s"% sample_objective.complete)
	
func _on_ObjectiveSample_on_objective_complete(_ObjectiveBase):

	get_tree().call_group(plant_group, "plant_group_sampled")
	plant_type_sampled = true
	if is_plant_group_complete():
		complete_objective()
	update_dialog()
func _on_ObjectivePhoto_on_objective_complete(ObjectiveBase):

	get_tree().call_group(plant_group, "plant_group_photoed")
	plant_type_photoed = true
	if is_plant_group_complete():
		complete_objective()
	update_dialog()

func _on_ObjectiveWhisker_on_objective_complete(_ObjectiveBase):
	update_dialog()
	if is_plant_group_complete() == false:
		if not plant_type_photoed:
			photo_objective.enabled = true 
		if not plant_type_sampled:
			sample_objective.enabled = true 
	else:
		print("This groups has been completed")
func on_plant_group_complete():
	photo_objective.enabled = false
	sample_objective.enabled = false
	photo_objective.get_node("Trigger").enabled = true
	sample_objective.get_node("Trigger").enabled = true
	hint_action.enabled = false

func enable_already_done():
	hint_already_done.enabled = true
	photo_objective.get_node("Trigger").enabled = true
	sample_objective.get_node("Trigger").enabled = true
func plant_group_photoed():
	print("Group %s has been photoed plant group status = %s" % [plant_group,is_plant_group_complete()] )
	plant_type_photoed = true
	photo_objective.enabled = false

	enable_already_done()
	if is_plant_group_complete():
		hint_already_done.current_hint_key = "mission_fauna_plant_already_done1"
		on_plant_group_complete()
	else:
		hint_already_done.current_hint_key = "mission_fauna_plant_already_photoed"

func plant_group_sampled():
	print("Group %s has been sampled group status = %s" % [plant_group,is_plant_group_complete()] )
	plant_type_sampled = true
	sample_objective.enabled = false
	enable_already_done()

	if is_plant_group_complete():
		on_plant_group_complete()
		hint_already_done.current_hint_key = "mission_fauna_plant_already_done1"
	else:
		hint_already_done.current_hint_key = "mission_fauna_plant_already_sampled"

func Photo_on_trigger():
	if whisker_objective.complete and plant_type_photoed:
		hint_already_done.show_hint()

func Sample_on_trigger():
	if whisker_objective.complete and plant_type_sampled:
		hint_already_done.show_hint()

