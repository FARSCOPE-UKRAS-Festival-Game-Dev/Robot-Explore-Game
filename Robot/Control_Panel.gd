extends Control

# Declare member variables here. Examples:
onready var camera_hud = $MarginContainer/Panel/MarginContainer/GridContainer/Panel/MarginContainer/Camera_Sensor_HUD
onready var lidar_hud = $MarginContainer/Panel/MarginContainer/GridContainer/Panel2/MarginContainer/Lidar_Sensor_HUD
onready var whisker_hud = $MarginContainer/Panel/MarginContainer/GridContainer/Panel3/MarginContainer/Whisker_Sensor_HUD

# Called when the node enters the scene tree for the first time.
func _ready():
	var globals = get_node('/root/Globals')
	globals.show_joystick()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_camera_render_target(texture):
	var image = texture.get_data()
	var width = camera_hud.rect_size[0]
	var height = camera_hud.rect_size[1]
	image.resize(width, height)
	var itex = ImageTexture.new()
	itex.create_from_image(image)
	camera_hud.set_render_target(texture)

func set_lidar_render_target(texture):
	lidar_hud.set_render_target(texture)
	
func set_whisker_render_target(texture):
	whisker_hud.set_render_target(texture)
