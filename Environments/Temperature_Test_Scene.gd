extends Spatial

var texture = ImageTexture.new()
var tex_render = Image.new()
onready var overlay = $PanelContainer/Overlay
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Robot_with_sensor/Robot/TemperatureSensor.calibrate_from_body($Temp_calibration_heatmap)
	tex_render.load("res://Assets/heatmap.png")
	tex_render.convert(Image.FORMAT_RGB8)
	texture.create_from_image(tex_render)
	$Thermometer.register_sensor($Robot_with_sensor/Robot/TemperatureSensor)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var tex_pos = $Robot_with_sensor/Robot/TemperatureSensor.get_current_texture_pos()
	
	
	tex_render.lock()
	tex_render.set_pixel(tex_pos.x,tex_pos.y,Color(1,0,0,1))
	tex_render.unlock()
	
	texture.set_data(tex_render)
	
	overlay.texture = texture
	
