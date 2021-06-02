extends ObjectiveBase

func set_enable(value):
	.set_enable(value)
	$ObjectiveTrigger.enabled = value
	
func _on_ObjectiveTrigger_on_trigger():
	if enabled:
		complete_objective()

