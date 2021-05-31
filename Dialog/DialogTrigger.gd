extends Area

export var dialog_text_key = "dialog1"
var dialog_text= ""
var max_trigger_count = 1

func load_text_from_file():
	var file = File.new()
	
	file.open("res://Dialog/dialog_JSON.json", File.READ)
	var dialog_dict =  parse_json(file.get_as_text())
	dialog_text = dialog_dict[dialog_text_key]
	
func _ready():
	load_text_from_file()


func _on_DialogTrigger_body_entered(body):

		if body.get_name() == "Robot":
			if max_trigger_count > 0:
				max_trigger_count-=1
				body.get_parent().recieve_dialog(dialog_text)
		
