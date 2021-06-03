extends PanelContainer


export var text = "" setget set_text

func set_text(value):
	$MarginContainer/VBoxContainer/LogText.text = value
