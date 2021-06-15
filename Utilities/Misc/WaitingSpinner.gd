extends Control
signal completed

const GREEN_CIRCLE = preload("res://Assets/Images/greendot.png")
const RED_CIRCLE = preload("res://Assets/Images/reddot.png")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var rev_p_sec = 1.0
export var duration_seconds = 5.0

onready var sp = $SpinnerContainer/Spinner

var stop = false
var start_time;
var toggle = false


# Called when the node enters the scene tree for the first time.
func _ready():
	start_time = OS.get_unix_time()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var new_value = sp.value + delta * sp.max_value / rev_p_sec 
	sp.value = fmod(new_value, sp.max_value)
	
	if new_value > sp.max_value:
		toggle = !toggle
	
	if toggle:
		sp.set_under_texture(GREEN_CIRCLE)
		sp.set_progress_texture(RED_CIRCLE)
	else:
		sp.set_under_texture(RED_CIRCLE)
		sp.set_progress_texture(GREEN_CIRCLE)
	if stop or (OS.get_unix_time() - start_time > duration_seconds):
		queue_free()
			
func spin_stop():
	stop = true
