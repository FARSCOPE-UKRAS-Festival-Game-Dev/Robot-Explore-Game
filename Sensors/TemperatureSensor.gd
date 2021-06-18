extends "BaseSensor.gd"

# Texture can be created with https://github.com/hendrikE/Heatmap

#Where the sensor is in the heatmap texture. Ignore the z component it's there so can use matrix math

var texture_pos = Vector3(0,0,0)

#The sensor body, used to locate the sensor in worldspace
onready var sensor_body = $SensorBody

#The heatmap texture
var temperature_heatmap = Image.new()

#The matrix which converts between world space and texture space
var CALLIBRATION_MATRIX = Transform.IDENTITY

#The range of temperature values, maps between pixel values and temperatures
export var TEMPERATURE_LIMITS = Vector2(0,100)

const AMBIENT_TEMPERATURE = 10

#The size of the heatmap in pixels
var HEATMAP_RESOLUTION = Vector2(0,0)

#True if a valid heatmap has been assigned to this sensor
var calibrated = false

###########GUI variables##########

#Height of the bar section of the thermobar_texture
var BAR_HEIGHT = 241 
#Bottom of the bar section in pixel coordinates
var BAR_START_Y = 310 

#Preload background image with themometer scale and the bar overlay
var bar_img = preload("res://Assets/Images/TemperatureSensor/Thermobar.png")
var bkgd_img = preload("res://Assets/Images/TemperatureSensor/Thermometer.png")
var texture_output = ImageTexture.new()



func _ready():
	texture_output.create_from_image(bkgd_img)

func get_temperature_range():
	#Returns the difference between the maximum and minimum temperature
	return TEMPERATURE_LIMITS.y-TEMPERATURE_LIMITS.x

func get_current_texture_pos():
	#Returns the position of the sensor in the heatmap texture
	texture_pos = CALLIBRATION_MATRIX.xform(sensor_body.global_transform.origin)
	return texture_pos

func get_temperature():
	#Returns the temperature based on the sensor location and temperature heatmap
	if calibrated:
		#Establish sensors current postion in the texture
		get_current_texture_pos()
		
		#If the robot goes outside of the texture then the closest edge pixels will be returned
		var heatmap_pos = texture_pos
		heatmap_pos.x = clamp(heatmap_pos.x,0,temperature_heatmap.get_width()-1)
		heatmap_pos.y = clamp(heatmap_pos.y,0,temperature_heatmap.get_height()-1)
		
		#Access heatmap at the postion the robot is at within the heatmap	
		temperature_heatmap.lock()
		var heatmap_value = temperature_heatmap.get_pixel(int(floor(heatmap_pos.x)),int(floor(heatmap_pos.y))).gray()
		temperature_heatmap.unlock()
		
		#Convert pixel value to temperature
		heatmap_value = float(heatmap_value)*(TEMPERATURE_LIMITS.y-TEMPERATURE_LIMITS.x) - TEMPERATURE_LIMITS.x
		return min(TEMPERATURE_LIMITS.y, heatmap_value + AMBIENT_TEMPERATURE)
	else:
		return TEMPERATURE_LIMITS.x


func render_view():
	#Get the current temperature
	var current_temp = get_temperature()
	#Drawing the thermometer consists of overlaying a cropped bar image over the thermometer scale image

	var thermometer_bar = Image.new()
	thermometer_bar.copy_from(bar_img)

	#bar_top_y represents the the top y co-ordinate of the pixel bar. Remember pixel co-ordinates go from top to bottom
	var bar_top_y = BAR_START_Y - BAR_HEIGHT/get_temperature_range()*current_temp
	#crop the bar overlay accordingly
	var crop_rect = Rect2(0,bar_top_y,thermometer_bar.get_width(),thermometer_bar.get_height()-bar_top_y)

	var thermometer = Image.new()
	thermometer.copy_from(bkgd_img)

	#blend the cropped bar image and background scale
	thermometer.blend_rect(thermometer_bar,crop_rect,Vector2(0,bar_top_y))

	texture_output.set_data(thermometer)
	
	return texture_output
	
func calibrate_from_body(body):

		assert(body.get_child(0).name == "Sensor_extent","ERROR body is not a calibration body") 
		var c_body = body.get_child(0)

		var temperature_heatmap_img = c_body.find_node("Heatmap_display").get_active_material(0).get_texture(0).get_data()
		temperature_heatmap_img.convert(Image.FORMAT_L8)
		temperature_heatmap = Image.new()
		#var data = temperature_heatmap_img.get_data()
		
		temperature_heatmap =temperature_heatmap_img
		HEATMAP_RESOLUTION.x = temperature_heatmap.get_width()
		HEATMAP_RESOLUTION.y = temperature_heatmap.get_height()

		#NOTE this only takes the transform relative to parent. So we don't use the c_body node and do all scaling on the parent
		var c_transform = body.transform.affine_inverse()
		#Convert between calibration body space and texture space, we ignore the z coordinate in texture space
		CALLIBRATION_MATRIX =  c_transform.rotated(Vector3(1,0,0),-PI/2).scaled(Vector3(HEATMAP_RESOLUTION.x/2,HEATMAP_RESOLUTION.y/2,1))
		CALLIBRATION_MATRIX.origin +=   transform.basis.x * HEATMAP_RESOLUTION.x/2
		CALLIBRATION_MATRIX.origin +=   transform.basis.y * HEATMAP_RESOLUTION.y/2

		calibrated = true

