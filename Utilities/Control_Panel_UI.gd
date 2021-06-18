extends Control

onready var anim = $AnimationPlayer
onready var fade_overlay = $FadeOverlay
func _ready():
	fade_overlay.hide()
	fade_overlay.color.a = 1.0
	
func fade_in():
	set_enable_fade_overlay(true)
	anim.playback_speed = 1
	anim.play("fade_in")
	anim.connect("animation_finished",self,"on_anim_finished",[false],CONNECT_ONESHOT)

func on_anim_finished(anim_name,enabled):
	set_enable_fade_overlay(enabled)
	
func set_enable_fade_overlay(value):
	if value:
		fade_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
		fade_overlay.show()
	else:
		fade_overlay.hide()
		fade_overlay.mouse_filter = Control.MOUSE_FILTER_PASS
		
func fade_out():
	set_enable_fade_overlay(true)
	anim.play_backwards("fade_in")
	anim.connect("animation_finished",self,"on_anim_finished",[true],CONNECT_ONESHOT)
