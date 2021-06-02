extends Control
onready var text_label = $PanelContainer/MarginContainer/TextLabel
signal on_fade_in_finish
signal on_fade_out_start
signal on_fade_out_finish

export var playing = false

func display_text(text):
	show()
	playing = true
	text_label.text = text
	$AnimationPlayer.play("Mission_fade")

func on_fade_in_finish():

	emit_signal("on_fade_in_finish")

func on_fade_out_finish():
	emit_signal("on_fade_out_finish")
	playing = false

func on_fade_out_start():
	emit_signal("on_fade_out_start")
func _ready():
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
