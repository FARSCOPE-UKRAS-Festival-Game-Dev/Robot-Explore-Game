extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var hud = $Display
var sensor_class = null

var enabled = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_sensor_class(sclass):
	sensor_class = sclass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if sensor_class != null and enabled:
		var texture = sensor_class.render_view()
		_render_texture_to_hud(texture)

func _render_texture_to_hud(texture):
	hud.texture = texture
	

