
extends TriggeredResource


# Triggers sound when child trigger is activated. To change sound use editable children

onready var sound = $Sound
func on_triggered():
	sound.play()
