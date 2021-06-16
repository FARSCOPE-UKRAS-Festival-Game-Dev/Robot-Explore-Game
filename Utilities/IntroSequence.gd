extends Control

export var NEXT_SCENE = "res://Environments/TutorialSection/TutorialSection.tscn"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const ANIMATION_ORDER = [ 
	"scene1",
	"scene2",
	"scene3"
]


# Called when the node enters the scene tree for the first time.
func _ready():	
	for anim in ANIMATION_ORDER:
		$AnimationPlayer.queue(anim)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	if len($AnimationPlayer.get_queue()) < 0:
		exit_intro()
		
	if Input.is_action_pressed("ui_cancel"):
		skip_button()
	
	if Input.is_action_pressed("ui_select"):
		stop_current_animation()
			
func stop_current_animation():
	fade_out(3.0)
	yield($FadeAnimation, "animation_finished")
	$AnimationPlayer.seek($AnimationPlayer.current_animation_length)

func fade_in(speed=1.0):
	$FadeAnimation.play("fade in", -1, speed)
	
func fade_out(speed=1.0):
	$FadeAnimation.play("fade out", -1, speed)

func exit_intro():
	queue_free()
	print('Finished')
#	Globals.goto_scene(NEXT_SCENE)

func skip_button():
	fade_out(3.0)
	yield($FadeAnimation, "animation_finished")
	exit_intro()

func _on_Timer_timeout():
	$Extras/Button.visible = true
	$Extras/Timer2.start()

func _on_Timer2_timeout():
	$Extras/Button.visible = false
