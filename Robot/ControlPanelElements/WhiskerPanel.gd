extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var hud = $AspectRatioContainer/Panel/Display
onready var lights = [
	$AspectRatioContainer/Panel/Red1,
	$AspectRatioContainer/Panel/Red2,
	$AspectRatioContainer/Panel/Red3,
	$AspectRatioContainer/Panel/Red4,
	$AspectRatioContainer/Panel/Red5,
	$AspectRatioContainer/Panel/Red6
]
onready var whisker_anim = $AspectRatioContainer/Panel/Display/AnimatedSprite
onready var text_holder = $AspectRatioContainer/Panel/Label
var sensor_class = null

onready var redlight = load("res://Assets/Images/reddot.png")
onready var greenlight = load("res://Assets/Images/greendot.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	whisker_anim.play("idle")

func set_sensor_class(sclass):
	sensor_class = sclass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if sensor_class != null:
		var texture = sensor_class.render_view()
		_render_texture_to_hud(texture)
		var text = sensor_class.render_text()
		_render_text_to_hud(text)
		var touching = sensor_class.touching
		_render_lights_to_hud(touching)

func _render_texture_to_hud(texture):
	var image = texture.get_data()
	var width = hud.rect_size[0]
	var height = hud.rect_size[1]
	image.resize(width, height)
	var itex = ImageTexture.new()
	itex.create_from_image(image)
	hud.texture = itex
	
func _render_text_to_hud(text):
	text_holder.text = text
	
func _render_lights_to_hud(touching):
	for i in range(len(touching)):
		if touching[i] == 1:
			lights[i].texture = redlight
		else:
			lights[i].texture = greenlight

func _on_AnimatedSprite_animation_finished():
	whisker_anim.play("idle")

func _on_ControlPanel_whisker_signal():
	whisker_anim.rotation_degrees = randi()%4*90
	whisker_anim.flip_v  = bool(randi()%2)
	whisker_anim.flip_h  = bool(randi()%2)
	whisker_anim.play("reveal")