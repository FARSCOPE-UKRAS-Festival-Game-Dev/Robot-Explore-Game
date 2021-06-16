extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var flash_duration = 0.1

onready var viewport = $Viewport
onready var camera = $Viewport/Camera
onready var image = $MarginContainer/Image

var show_on_screen = false
var take_picture = false
var duration_on_screen
var start_time
var camera_transform
var snapshot
var play_animation = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$Viewport.set_update_mode(Viewport.UPDATE_ALWAYS)
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame") 
	viewport.size = image.rect_size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if show_on_screen:
		
		# Other stuff?
		if (OS.get_unix_time() - start_time) > duration_on_screen:
			stop()
		else:
			var imtext = ImageTexture.new()
			imtext.create_from_image(snapshot)
			image.set_texture(imtext)
			if play_animation:
				$AnimateImage.play("Flash")
				play_animation = false
			
			
	if take_picture:
		camera.global_transform = camera_transform
		var text = viewport.get_texture()
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame") 
		snapshot = text.get_data()
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame") 
		start_time = OS.get_unix_time()
		show_on_screen = true
		take_picture = false
		
	if Input.is_action_pressed("ui_select"):
		stop()
		
func take_picture(_camera_transform, _duration_on_screen):
	camera_transform = _camera_transform
	duration_on_screen = _duration_on_screen
	take_picture = true
	
	image.get_node("Label").text = \
		"Location: x = %s, y = %s" \
		% [camera_transform.origin.x, camera_transform.origin.y]

func stop():
	$AnimateImage.play("Dissapear")
	
func stop_all():
	queue_free()

func _on_MarginContainer_gui_input(event):
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.pressed:
			stop()

func play_sound():
	Globals.play_sound("camera_snap", -10.0)
