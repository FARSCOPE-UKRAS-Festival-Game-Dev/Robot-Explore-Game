extends Control

onready var anim = $AnimationPlayer
onready var fade_overlay = $FadeOverlay
func _ready():
	fade_overlay.hide()
	anim.connect("animation_finished",self,"on_anim_finished")

func fade_in():
	set_enable_fade_overlay(true)
	anim.playback_speed = 1
	anim.play("fade_in")
func on_anim_finished(anim_name):
	set_enable_fade_overlay(false)
func set_enable_fade_overlay(value):
	if value:
		fade_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
		fade_overlay.show()
	else:
		fade_overlay.hide()
		fade_overlay.mouse_filter = Control.MOUSE_FILTER_PASS
func fade_out():
	set_enable_fade_overlay(true)
	anim.playback_speed = -1
	anim.play("fade_in")


