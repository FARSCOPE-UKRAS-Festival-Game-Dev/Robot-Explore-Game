extends Area

export var dialog_text_key = "dialog1"
export(bool) var trigger_on_touch = true
var dialog_text= ""
var max_trigger_count = 1
var robot

func _ready():
	robot =  get_tree().get_root().get_node("Robot")

func trigger_dialog():
	robot.trigger_dialog()

func _on_DialogTrigger_body_entered(body):

		if trigger_on_touch and body.get_name() == "Robot":
			if max_trigger_count > 0:
				max_trigger_count-=1
				trigger_dialog()
