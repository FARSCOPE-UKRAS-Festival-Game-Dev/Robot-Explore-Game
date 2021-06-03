extends ObjectiveBase
onready var trigger = null

#A single objective completed by the trigger activating
#can either be used on its own or as a child of MultiObjective 

func set_enable(value):
	.set_enable(value)
	if trigger != null:
		trigger.enabled = value

func _ready():	
	trigger = get_node_or_null("Trigger")
	if trigger != null:
		trigger.enabled = enabled
		trigger.connect("on_trigger",self,"_on_ObjectiveTrigger_on_trigger")
func _on_ObjectiveTrigger_on_trigger():
	if enabled:
		complete_objective()

