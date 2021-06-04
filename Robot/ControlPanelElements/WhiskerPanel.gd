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
var sensor_class = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_sensor_class(sclass):
	sensor_class = sclass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if sensor_class != null:
		var texture = sensor_class.render_view()
		_render_texture_to_hud(texture)

func _render_texture_to_hud(texture):
	var image = texture.get_data()
	var width = hud.rect_size[0]
	var height = hud.rect_size[1]
	image.resize(width, height)
	var itex = ImageTexture.new()
	itex.create_from_image(image)
	hud.texture = itex

func collision_leds_set(set):
	for l in lights:
		l.visible = set
