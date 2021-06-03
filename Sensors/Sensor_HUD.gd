extends Control

func set_render_target(target_texture):
	$Panel/TextureRect.texture = target_texture 

func set_text(text):
	$Panel/Text.text = text
