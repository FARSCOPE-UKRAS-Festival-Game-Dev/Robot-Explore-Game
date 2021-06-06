extends Control
onready var text_label = $MarginContainer/PanelContainer/MarginContainer/TextLabel

signal on_fade_in_finish
signal on_fade_out_start
signal on_fade_out_finish
signal on_display_idle_complete

const MAX_QUEUE_LENGTH = 3

export var playing = false

var text_queue = []

func display_text(text):
	

	if text_queue.size() >= MAX_QUEUE_LENGTH:
		text_queue.pop_front()
	text_queue.push_back(text)
	
	if not playing:
		text_label.text = text_queue.pop_front()
		show()
		playing = true
		$AnimationPlayer.play("fade_in_with_text_scroll")
		



func on_fade_in_finish():
	emit_signal("on_fade_in_finish")

func on_fade_out_finish():
	emit_signal("on_fade_out_finish")
	playing = false
	hide()
func on_fade_out_start():
	emit_signal("on_fade_out_start")

func on_display_idle_complete():
	emit_signal("on_display_idle_complete")
	if not text_queue.empty():
		text_label.text = text_queue.pop_front()
		$AnimationPlayer.play("text_scroll_only")
	else:
		$AnimationPlayer.play("fade_out_with_text_scroll")
		

func _ready():
	hide()


