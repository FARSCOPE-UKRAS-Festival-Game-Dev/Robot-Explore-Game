extends ObjectiveBase

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
export(PlantType) var plant_type = PlantType.A setget set_plant_type
var plant_group = null

var plant_type_photoed = false
var plant_type_sampled = false
enum PlantNodeState {
	NOT_ENABLED,
	ENABLED_NOT_WHISKERED,
	NOT_PHOTOED_NOT_SAMPLED,
	PHOTOED_NOT_SAMPLED,
	SAMPLED_NOT_PHOTOED,
	GROUP_COMPLETE
}

var node_state

onready var photo_trigger= get_node("PhotoTrigger")
onready var sample_trigger=  get_node("SampleTrigger")
onready var whisker_trigger =  get_node("WhiskerTrigger")

var node_whiskered = false

onready var hint_action = $NextActionHint
onready var hint_already_done = $AlreadyDoneHint

var photo_on_complete_dialogue
var sample_on_complete_dialogue
var whisker_on_complete_dialogue
var whisker_already_completed_dialogue


var material = preload("res://Sensors/TactileInfo.gd").material

func set_plant_type(type):
	plant_type = type
	var plant_colour = Color(1.0,1.0,1.0)
	var tactile_mat
	match plant_type:
		PlantType.A:
			plant_colour = Color(0.5,0.0,0.5)
			tactile_mat = material.PlantSpeciesA
		PlantType.B:
			plant_colour = Color(1.0,0.0,0.0)
			tactile_mat = material.PlantSpeciesB
		PlantType.C:
			plant_colour = Color(0.0,1.0,0.0)
			tactile_mat = material.PlantSpeciesC
		PlantType.D:
			plant_colour = Color(0.0,0.0,1.0)
			tactile_mat = material.PlantSpeciesD
		PlantType.E:
			plant_colour = Color(0.0,0.5,1.0)
			tactile_mat = material.PlantSpeciesE
	if is_inside_tree():
		$Plant/TactileInfo.type = tactile_mat
		
func complete_objective():
	.complete_objective()
	
func is_plant_group_complete():
	return plant_type_photoed and plant_type_sampled

func set_action_hint(hint_key):
	hint_action.set_first_hint_dialog_key(hint_key)


func set_already_done_hint(hint_key):
	hint_already_done.set_first_hint_dialog_key(hint_key)



func set_enable(value):
	if not Engine.editor_hint:
		.set_enable(value)
		if enabled:
			node_state = PlantNodeState.ENABLED_NOT_WHISKERED
		else:
			node_state = PlantNodeState.NOT_ENABLED
		if is_inside_tree():
			update_plant_node_logic()
		
func _ready():
	if not Engine.editor_hint:
		if plant_object == null:
			plant_object = "Plant"
			if get_node_or_null(plant_object) == null:
				print("%s plant objective as no plant object" % name)
			else:
				plant_object = "../Plant"
		whisker_trigger.must_whisker = plant_object
		photo_trigger.must_see = plant_object
		photo_trigger.must_see_enable = true
		whisker_trigger.must_whisker_enable = true
		
		plant_group  = "flora_mission_plant_grp_%d" % plant_type
		add_to_group(plant_group)
		
		if enabled:
			node_state = PlantNodeState.ENABLED_NOT_WHISKERED
		else:
			node_state = PlantNodeState.NOT_ENABLED 
		update_plant_node_logic()
		set_plant_type(plant_type)
		init_dialog()
		
func init_dialog():
	if plant_dialog_set == null:
		plant_dialog_set = randi()%NUM_DIALOG_SETS + 1
		
	photo_on_complete_dialogue = "mission_fauna_got_photo%d" % plant_dialog_set
	sample_on_complete_dialogue = "mission_fauna_got_sample%d" % plant_dialog_set
	whisker_on_complete_dialogue = "mission_fauna_got_whiskers%d" % plant_dialog_set
	whisker_already_completed_dialogue = "mission_fauna_whiskered_plant_already_done%d" % plant_dialog_set

	on_complete_dialogue = "mission_fauna_completed_plant%s" % enum_to_letter[plant_type]
	
func change_sample_photo_state():
	#print("enabled %s whiskered %s photo %s sampled %s" % [enabled,node_whiskered,plant_type_photoed,plant_type_sampled])
	if not plant_type_photoed and not plant_type_sampled and node_whiskered and enabled:
		node_state = PlantNodeState.NOT_PHOTOED_NOT_SAMPLED
	elif plant_type_photoed and not plant_type_sampled:
		node_state = PlantNodeState.PHOTOED_NOT_SAMPLED
	elif plant_type_sampled and not plant_type_photoed:
		node_state = PlantNodeState.SAMPLED_NOT_PHOTOED
	elif is_plant_group_complete():
		node_state = PlantNodeState.GROUP_COMPLETE
		
func update_plant_node_logic():
	#print("Plant state changing to : %d " % node_state)
	match node_state:
		
		PlantNodeState.NOT_ENABLED:
			whisker_trigger.enabled = false
			photo_trigger.enabled = false
			sample_trigger.enabled = false
			hint_already_done.enabled = false
			hint_action.enabled = false

		PlantNodeState.ENABLED_NOT_WHISKERED:
			node_whiskered = false

			whisker_trigger.enabled = true
			photo_trigger.enabled = false
			sample_trigger.enabled = false
			hint_already_done.enabled = false
			set_action_hint("mission_fauna_need_photo_sample1")
			hint_action.enabled = false
			
		PlantNodeState.NOT_PHOTOED_NOT_SAMPLED:
			set_action_hint("mission_fauna_need_photo_sample1")
			hint_action.enabled = true
			sample_trigger.enabled = true
			photo_trigger.enabled = true
	
		
		PlantNodeState.PHOTOED_NOT_SAMPLED:
			hint_action.set_current_hint_key("debug_hint1")
			set_action_hint("mission_fauna_just_need_sample1")
			set_already_done_hint("mission_fauna_plant_already_photoed")
			hint_action.enabled = true
			hint_already_done.enabled = true
		PlantNodeState.SAMPLED_NOT_PHOTOED:
			set_action_hint("debug_hint2")	
			set_action_hint("mission_fauna_just_need_photo1")
			set_already_done_hint("mission_fauna_plant_already_sampled")
			hint_action.enabled = true
			hint_already_done.enabled = true
			
		PlantNodeState.GROUP_COMPLETE:
			hint_action.enabled = false
			set_already_done_hint("mission_fauna_plant_already_done1")
			photo_trigger.enabled = true
			sample_trigger.enabled = true
			

func on_plant_group_photoed():
	print("Group %s has been photoed plant group status = %s" % [plant_group,is_plant_group_complete()] )
	
	plant_type_photoed = true
	change_sample_photo_state()
	update_plant_node_logic()

func on_plant_group_sampled():
	print("Group %s has been sampled group status = %s" % [plant_group,is_plant_group_complete()] )
	plant_type_sampled = true

	change_sample_photo_state()
	update_plant_node_logic()
	
func _on_WhiskerTrigger_on_trigger():
	print("Plant has been whiskered")
	if node_whiskered == false:
		if not is_plant_group_complete():
			Globals.queue_dialog(whisker_on_complete_dialogue)
	node_whiskered = true
	
	change_sample_photo_state()
	update_plant_node_logic()
	if is_plant_group_complete():
		Globals.queue_dialog(whisker_already_completed_dialogue)
		

func Photo_on_trigger():

	print("Plant has been photo")
	if not plant_type_photoed:
		plant_type_photoed = true
		Globals.queue_dialog(photo_on_complete_dialogue)
		get_tree().call_group(plant_group, "on_plant_group_photoed")
		if is_plant_group_complete():
			complete_objective()
		return
	if node_whiskered and plant_type_photoed:
		print("OLA")
		hint_already_done.show_hint()

func Sample_on_trigger():
	print("Plant has been sampled")
	if not plant_type_sampled:
		plant_type_sampled = true
		Globals.queue_dialog(sample_on_complete_dialogue)
		get_tree().call_group(plant_group, "on_plant_group_sampled")
		if is_plant_group_complete():
			complete_objective()
		return
		
	if node_whiskered and plant_type_sampled:
		hint_already_done.show_hint()
		print("showing akready done hint")

