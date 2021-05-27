extends "BaseSensor.gd"

# Texture can be created with https://github.com/hendrikE/Heatmap



var texture_pos = Vector3(0,0,0)
onready var body = $CollisionShape
var temperature_heatmap = Image.new()

var CALLIBRATION_MATRIX = Transform.IDENTITY
export var TEMPERATURE_LIMITS = Vector2(0,100)
var HEATMAP_RESOLUTION = Vector2(256,256)

var calibrated = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func get_temperature_range():
	return TEMPERATURE_LIMITS.y-TEMPERATURE_LIMITS.x
# Called every frame. 'delta' is the elapsed time since the previous frame.
# Call temp texture
# Determine value
# Rescale from 0 to 100

func get_current_texture_pos():
	return texture_pos

func get_temperature():
	if calibrated:
		var heatmap_pos = texture_pos
		heatmap_pos.x = clamp(heatmap_pos.x,0,temperature_heatmap.get_width())
		heatmap_pos.y = clamp(heatmap_pos.y,0,temperature_heatmap.get_height())
		
		
		temperature_heatmap.lock()
		var heatmap_value = temperature_heatmap.get_pixel(int(floor(heatmap_pos.x)),int(floor(heatmap_pos.y))).gray()
		temperature_heatmap.unlock()
		
		heatmap_value = float(heatmap_value)*(TEMPERATURE_LIMITS.y-TEMPERATURE_LIMITS.x) - TEMPERATURE_LIMITS.x
		print(heatmap_value)
		return heatmap_value
	

func _process(delta):
	 texture_pos = CALLIBRATION_MATRIX.xform(body.global_transform.origin)

	# Render temperature taken by sensor
func _render_view():
	# Set thermometer value to temperature
	pass

func calibrate_from_body(body):
		
		assert(body.get_child(0).name == "Sensor_extent","ERROR body is not a calibration body") 
		
		var c_body = body.get_child(0)
		var c_transform = c_body.transform.affine_inverse()
		
		#Convert between calibration body space and texture space, we ignore the z coordinate in texture space
		CALLIBRATION_MATRIX =  c_transform.rotated(Vector3(1,0,0),-PI/2).scaled(Vector3(HEATMAP_RESOLUTION.x/2,HEATMAP_RESOLUTION.y/2,1))
		CALLIBRATION_MATRIX.origin +=   transform.basis.x * HEATMAP_RESOLUTION.x/2
		CALLIBRATION_MATRIX.origin +=   transform.basis.y * HEATMAP_RESOLUTION.y/2
		
		var temperature_heatmap_img = c_body.find_node("Heatmap_display").get_active_material(0).get_texture(0).get_data()
		temperature_heatmap_img.convert(Image.FORMAT_L8)

		temperature_heatmap = Image.new()
		var data = temperature_heatmap_img.get_data()
		
		
		#data.decompress(temperature_heatmap_img.get_width(),temperature_heatmap_img.get_height)
		temperature_heatmap =temperature_heatmap_img #.create_from_data(temperature_heatmap_img.get_width(),temperature_heatmap_img.get_height(),false,temperature_heatmap_img.get_format(),data)
		 
		calibrated = true
