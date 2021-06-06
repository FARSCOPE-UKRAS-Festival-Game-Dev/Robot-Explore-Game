extends Control


onready var lights = [
	$AspectRatioContainer/Panel/Red1,
	$AspectRatioContainer/Panel/Red2,
	$AspectRatioContainer/Panel/Red3,
	$AspectRatioContainer/Panel/Red4,
	$AspectRatioContainer/Panel/Red5,
	$AspectRatioContainer/Panel/Red6
]

onready var texture_display = $AspectRatioContainer/Panel/Display
onready var whisker_anim = $AnimationPlayer
onready var display_text = $AspectRatioContainer/Panel/TextPanel/DisplayText


var sensor_class = null

onready var redlight = load("res://Assets/Images/reddot.png")
onready var greenlight = load("res://Assets/Images/greendot.png")

#Animation stuff

onready var	whisker_analyse = $AspectRatioContainer/Panel/WhiskerAnalyse
onready var whisker_reveal = $AspectRatioContainer/Panel/WhiskerReveal
onready var whisker_wipe = $AspectRatioContainer/Panel/WhiskerAnalyseWipe

var key_point_preload = preload("res://Assets/Images/WhiskerKeyPoint.png")
var overlay_format = Image.new()
var texture_output = ImageTexture.new()

const DISPLAY_RESOLUTION = Vector2(512,167)#This is the size of the window in the whisker display texture
const KEY_POINT_REL_SIZE = Vector2(0.05,0.05)
const MIN_KEY_POINTS = 5 #Number of keypoints is random between these limits
const MAX_KEY_POINTS = 12
const KEY_POINT_APPEAR_PERIOD = 1.0 # period over which keyframes MUST be displayed
const KEYFRAME_MARGIN  = 10 # how far keyframes can get to the edge

func _ready():

	texture_display.texture = null
	display_text.text = ""
	
	overlay_format.create(DISPLAY_RESOLUTION.x,DISPLAY_RESOLUTION.y,false,Image.FORMAT_RGBA8)
	texture_output.create_from_image(overlay_format)
	var display_aspect = float(overlay_format.get_width())/overlay_format.get_height()
	key_point_preload.resize(overlay_format.get_width()*KEY_POINT_REL_SIZE.x,int(display_aspect*overlay_format.get_height()*KEY_POINT_REL_SIZE.y))
	
	reset_analyse_anim()


	#this fixes a bug with the animated texture, texture must play through at some point for one_shot to work correctly
	#make texture invisible and let it play
	whisker_reveal.texture.pause = false
	whisker_reveal.visible = false
	

func set_sensor_class(sclass):
	sensor_class = sclass
	sensor_class.connect("whisker_sense_new",self,"on_sense_new")
	sensor_class.connect("whisker_sense_none",self,"on_sense_none")
	sensor_class.connect("touching_changed",self,"on_touch_change")

func _render_texture_to_hud(texture):
	texture_display.texture = texture

func _render_lights_to_hud(touching):
	for i in range(len(touching)):
		if touching[i] == 1:
			lights[i].texture = redlight
		else:
			lights[i].texture = greenlight

func _render_text_to_hud():
	if sensor_class!= null:
		display_text.text = sensor_class.render_text()

func on_sense_new():
	var texture = sensor_class.render_view()
	_render_texture_to_hud(texture)
	play_analyse_anim()

func on_sense_none():
	texture_display.texture = null
	display_text.text = ""
func on_touch_change():
	var touching = sensor_class.touching
	_render_lights_to_hud(touching)
	
func remove_key_points():
	overlay_format.fill(Color(0,0,0,0))
	texture_output.set_data(overlay_format)
	whisker_analyse.visible = false

func place_key_point():
	randomize()

	var key_point = Image.new()
	key_point.copy_from(key_point_preload)
	whisker_analyse.visible = true
	var num_key_points = (randi() % MIN_KEY_POINTS)+MAX_KEY_POINTS
	var max_key_point_wait = KEY_POINT_APPEAR_PERIOD/num_key_points
	
	for i in num_key_points:

		var x_pos = (randi() % (overlay_format.get_width()-key_point.get_width()-KEYFRAME_MARGIN*2)) + KEYFRAME_MARGIN
		var y_pos = (randi() % (overlay_format.get_height()-key_point.get_height()-KEYFRAME_MARGIN*2)) + KEYFRAME_MARGIN
		var key_frame_pos = Vector2(x_pos,y_pos)#img_out.get_width()/2,img_out.get_height())
		overlay_format.blend_rect(key_point,key_point.get_used_rect(),key_frame_pos)
		yield(get_tree().create_timer(randf()*max_key_point_wait),"timeout")
		texture_output.set_data(overlay_format)
	
func reset_analyse_anim():
	whisker_analyse.texture = texture_output
	whisker_wipe.visible = false
	whisker_analyse.visible = false
	whisker_reveal.texture.pause = true
	whisker_reveal.texture.current_frame = 0
	whisker_reveal.texture.fps = 16
	remove_key_points()

func play_analyse_anim():
	reset_analyse_anim()
	whisker_reveal.visible = true
	whisker_reveal.texture.pause = false
	whisker_anim.stop()#stop all animations other wise previously queued animations might play on top of each over
	whisker_anim.clear_queue()
	whisker_anim.play("whisker_reveal")
	whisker_anim.queue("whisker_analyse")


