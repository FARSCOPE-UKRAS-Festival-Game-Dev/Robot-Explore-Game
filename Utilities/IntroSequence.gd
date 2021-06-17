extends Control

export var NEXT_SCENE = "res://Environments/TutorialSection/TutorialSection.tscn"
export var DIALOG_FILE = "res://Assets/Dialog/TutorialDialog.json"

const ANIMATION_ORDER = [ 
	"scene1",
	"scene2",
	"scene3"
]  

const ANIMATION_TO_DIALOG = {
	"scene1": "tutorial_scene1",
	"scene2": "tutorial_scene2",
	"scene3": "tutorial_scene3"
}

var current_scene_id = 0

# Called when the node enters the scene tree for the first time.
func _ready():	
	Globals.load_dialog_from_file(DIALOG_FILE)
	Globals.connect("all_dialog_finished", self, "play_next_scene")
	Globals.dialog_popup = get_node('DialogPopup')
	Globals.dialog_popup.connect("dialog_finished",Globals,"dialog_finished")
	Globals.dialog_popup.connect("finished_dialog_queue",Globals,"all_dialog_finished")
	play_current_scene() 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process_inputs()

func process_inputs():
	if Input.is_action_pressed("ui_cancel"):
		skip_button()

func play_current_scene():
	if current_scene_id < len(ANIMATION_ORDER):
		var scene = ANIMATION_ORDER[current_scene_id]
		$AnimationPlayer.play(scene)
		Globals.queue_dialog(ANIMATION_TO_DIALOG[scene])
	else:
		exit_intro()

func play_next_scene():
	if $AnimationPlayer.is_playing():
		fade_out(1.0)
		yield($FadeAnimation, "animation_finished")
		$AnimationPlayer.seek($AnimationPlayer.current_animation_length)
	current_scene_id += 1
	play_current_scene()

func fade_in(speed=1.0):
	$FadeAnimation.play("fade in", -1, speed)
	
func fade_out(speed=1.0):
	$FadeAnimation.play("fade out", -1, speed)

func skip_button():
	fade_out(3.0)
	yield($FadeAnimation, "animation_finished")
	exit_intro()

func _on_Timer_timeout():
	$Extras/Button.visible = true
	$Extras/Timer2.start()

func _on_Timer2_timeout():
	$Extras/Button.visible = false

func exit_intro():
	queue_free()
#	Globals.goto_scene(NEXT_SCENE)

