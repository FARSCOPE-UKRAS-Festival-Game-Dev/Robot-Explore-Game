extends Control

const CHAR_READ_RATE = 0.05

onready var textbox_container = $MarginContainer/TextboxContainer
onready var start_symbol = $MarginContainer/TextboxContainer/MarginContainer/HBoxContainer/Start
onready var end_symbol = $MarginContainer/TextboxContainer/MarginContainer/HBoxContainer/Finish
onready var label = $MarginContainer/TextboxContainer/MarginContainer/HBoxContainer/Text

enum State {
	READY,
	READING,
	FINISHED
}

signal finished_dialog_queue

var current_state = State.READY
var text_queue = []
var timeout = false
func _ready():
	print("Starting state: State.READY")
	hide_textbox()
#	queue_text("Excuse me wanderer where can I find the bathroom?")
#	queue_text("Why do we not look like the others?")
#	queue_text("Because we are free assets from opengameart!")
#	queue_text("Thanks for watching!")

func skip_input_pressed():
	return Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("dialog_skip") 

func _process(delta):
	match current_state:
		State.READY:
			if !text_queue.empty():
				display_text()
				timeout = false
		State.READING:
			if skip_input_pressed():
				label.percent_visible = 1.0
				$Tween.stop_all()
				end_symbol.text = "v"
				change_state(State.FINISHED)
		State.FINISHED:
			if timeout or skip_input_pressed():
				change_state(State.READY)
				if text_queue.empty():
					hide_textbox()
					emit_signal("finished_dialog_queue")
func queue_text(next_text):
	text_queue.push_back(next_text)

func hide_textbox():
	start_symbol.text = ""
	end_symbol.text = ""
	label.text = ""
	hide()

func show_textbox():
	start_symbol.text = "*"
	show()
	print("show har")
func display_text():
	
	var next_text = text_queue.pop_front()
	label.text = next_text
	label.percent_visible = 0.0
	change_state(State.READING)
	show_textbox()
	$Tween.interpolate_property(label, "percent_visible", 0.0, 1.0, len(next_text) * CHAR_READ_RATE, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func change_state(next_state):
	current_state = next_state
	match current_state:
		State.READY:
			pass
			#print("Changing state to: State.READY")
		State.READING:
			pass
			#print("Changing state to: State.READING")
		State.FINISHED:
			$TimeoutTimer.start()
			#print("Changing state to: State.FINISHED")

func _on_Tween_tween_completed(object, key):
	end_symbol.text = "v"
	change_state(State.FINISHED)
	

func _on_TimeoutTimer_timeout():
	if State.FINISHED:
		timeout = true

func _on_Textbox_visibility_changed():
	if $MarginContainer.visible:
		$MarginContainer.mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		$MarginContainer.mouse_filter = Control.MOUSE_FILTER_IGNORE

