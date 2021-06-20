extends PanelContainer


export var text = "" setget set_text
export(Texture) var texture setget set_texture

func set_title(value):
	var time = OS.get_time()
	var base = "[%d:%d:%d] %s" %  [time.hour, time.minute, time.second, value]
	$MarginContainer/VBoxContainer/MarginContainer/LogTitle.text = base

func set_text(value):
	$MarginContainer/VBoxContainer/LogText.visible = true
	$MarginContainer/VBoxContainer/LogImage.visible = false
	$MarginContainer/VBoxContainer/LogText.text = value

func set_texture(value):
	$MarginContainer/VBoxContainer/LogText.visible = false
	$MarginContainer/VBoxContainer/LogImage.visible = true
	$MarginContainer/VBoxContainer/LogImage.texture = value
