extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_render_target(target_texture):
	$Panel/TextureRect.texture = target_texture 

func set_text(text):
	$Panel/Text.text = text
