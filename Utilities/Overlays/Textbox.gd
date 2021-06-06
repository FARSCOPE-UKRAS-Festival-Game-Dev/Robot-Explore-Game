extends Control

const CHAR_READ_RATE = 0.05
const WAIT_TIME_COMPLETE = 3

onready var textbox_container = $MarginContainer/TextboxContainer
onready var start_symbol = $MarginContainer/TextboxContainer/MarginContainer/HBoxContainer/Start
onready var end_symbol = $MarginContainer/TextboxContainer/MarginContainer/HBoxContainer/Finish
onready var label = $MarginContainer/TextboxContainer/MarginContainer/HBoxContainer/Text

onready var audio_radio_on = $Audio/Radio_On
onready var audio_radio_constant = $Audio/Radio_Constant
onready var audio_radio_off = $Audio/Radio_Off

enum State {
	READY,
	READING,
	FINISHED
}

signal finished_dialog_queue
signal dialog_finished(dialog_key)
var current_state = State.READY
var text_queue = []
var timeout = false

var current_text = ""
var current_text_key = ""


func _ready():
	print("Starting state: State.READY")
	
	hide_textbox()
#	queue_text("Excuse me wanderer where can I find the bathroom?")
#	queue_text("Why do we not look like the others?")
#	queue_text("Because we are free assets from opengameart!")
#	queue_text("Thanks for watching!")

func skip_input_pressed():
	return Input.is_action_just_pressed("ui_accept") 

func _process(_delta):
	var skip_button = skip_input_pressed()
	match current_state:
		State.READY:
			if !text_queue.empty():
				display_text()
				timeout = false
				$TimeoutTimer.stop()
				$TimeoutTimer.wait_time = WAIT_TIME_COMPLETE
		State.READING:
			if skip_button:
				$TimeoutTimer.wait_time =  WAIT_TIME_COMPLETE + (len(current_text) * CHAR_READ_RATE)*(1.0-label.percent_visible)
				#print($TimeoutTimer.wait_time)
				label.percent_visible = 1.0
				$Tween.stop_all()
				end_symbol.text = "v"
				change_state(State.FINISHED)
		State.FINISHED:
			if timeout or skip_button:
				#print("dialog ending : timout = %d skip button = %d wait time = %d" % [int(timeout),int(skip_button),$TimeoutTimer.wait_time])
				emit_signal("dialog_finished",current_text_key)
				change_state(State.READY)
				if text_queue.empty():
					hide_textbox()
					emit_signal("finished_dialog_queue")
func queue_text(next_text,next_text_key):
	text_queue.push_back([next_text,next_text_key])

func hide_textbox():
	audio_radio_constant.stop()
	start_symbol.text = ""
	end_symbol.text = ""
	label.text = ""
	hide()

func show_textbox():
	audio_radio_constant.play()
	start_symbol.text = "*"
	show()

func display_text():
	
	var next_text_pair = text_queue.pop_front()
	current_text = next_text_pair[0]
	current_text_key = next_text_pair[1]
	label.text = current_text


	label.percent_visible = 0.0
	change_state(State.READING)
	show_textbox()
	$Tween.interpolate_property(label, "percent_visible", 0.0, 1.0, len(current_text) * CHAR_READ_RATE, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
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

func _on_Tween_tween_completed(_object,_key):
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
