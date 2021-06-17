extends Node

var texture = ImageTexture.new()
var tex_render = Image.new()
onready var overlay = $PanelContainer/Overlay
export var test_heatmap = "res://Assets/Images/MissionHeatmap.jpg"

# Test scene for temperature sensor. An overhead view and position of the robot within the heatmap are displayed
func _ready():
	if Globals.temp_debug:
	#	$Robot_with_sensors/Robot/TempLeft.calibrate_from_body($Temp_calibration_heatmap)
	#	$Robot_with_sensors/Robot/TempRight.calibrate_from_body($Temp_calibration_heatmap)
		tex_render.load(test_heatmap)
		tex_render.convert(Image.FORMAT_RGB8)
		texture.create_from_image(tex_render)
	else:
		queue_free() # So we don't forget to delete this
func _process(_delta):
	if Globals.robot != null:
		var tex_pos = Globals.robot.sensor_temp_left.get_current_texture_pos()
		var tex_pos_r = Globals.robot.sensor_temp_right.get_current_texture_pos()
		
		
		tex_render.lock()
		if (tex_pos.x > 0 and tex_pos.x < tex_render.get_width()) and (tex_pos.y > 0 and tex_pos.y < tex_render.get_height()):
			tex_render.set_pixel(tex_pos.x,tex_pos.y,Color(1,0,0,1))
		if (tex_pos_r.x > 0 and tex_pos_r.x < tex_render.get_width()) and (tex_pos_r.y > 0 and tex_pos_r.y < tex_render.get_height()):
			tex_render.set_pixel(tex_pos_r.x,tex_pos_r.y,Color(0,0,1,1))
		tex_render.unlock()
		
		texture.set_data(tex_render)
		
		overlay.texture = texture
		
