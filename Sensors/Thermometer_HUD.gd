extends TextureRect

var thermometer_callback
var thermometer_sensor
var BAR_HEIGHT = 241
var BAR_START_Y = 310
var bar_img = preload("res://Assets/Images/TemperatureSensor/Thermobar.png")
var bkgd_img = preload("res://Assets/Images/TemperatureSensor/Thermometer.png")
var texture_output = ImageTexture.new()
# Called when the node enters the scene tree for the first time.
func _ready():

	texture_output.create_from_image(bkgd_img)
	texture = texture_output

func _process(delta):
	if thermometer_sensor != null:
		var current_temp = thermometer_sensor.get_temperature()#thermometer_callback.call_func() # prints 'Hello'
		var thermometer_bar = Image.new()
		thermometer_bar.copy_from(bar_img)
		
		var bar_top_y = BAR_START_Y - BAR_HEIGHT/thermometer_sensor.get_temperature_range()*current_temp
		var crop_rect = Rect2(0,bar_top_y,thermometer_bar.get_width(),thermometer_bar.get_height()-bar_top_y)
		
		var thermometer = Image.new()
		thermometer.copy_from(bkgd_img)
		thermometer.blend_rect(thermometer_bar,crop_rect,Vector2(0,bar_top_y))
	
		texture_output.set_data(thermometer)
		
func register_sensor(sensor):
	thermometer_sensor = sensor
