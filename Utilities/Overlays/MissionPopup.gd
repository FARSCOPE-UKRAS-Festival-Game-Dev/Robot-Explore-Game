extends Control
onready var mission_name_label = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/MissionName

func popup(mission_name):
	
	mission_name_label.text = mission_name
	$AnimationPlayer.play("on_popup")
	$AnimationPlayer.queue("fade_out")
	show()
	
func _ready():
	hide()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_out":
		hide()
	$AnimationPlayer.stop()
