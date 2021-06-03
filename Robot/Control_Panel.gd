extends Control

# Declare member variables here. Examples:
onready var hud1 = $MarginContainer/Panel/Panel/MarginContainer/HUD1
onready var hud2 = $MarginContainer/Panel/Panel2/MarginContainer/HUD2
onready var hud3 = $MarginContainer/Panel/Panel3/MarginContainer/HUD3
onready var hud4 = $MarginContainer/Panel/Panel4/MarginContainer/HUD4
onready var hud5 = $MarginContainer/Panel/Panel5/MarginContainer/HUD5

onready var hud_to_id = [hud1, hud2, hud3, hud4, hud5]

onready var book_btn = $MarginContainer/Panel/OpenBookButton

onready var book_unread_texture = preload("res://Assets/Images/ControlPanel/Options6_unread.png")
onready var book_read_texture = preload("res://Assets/Images/ControlPanel/Options6.png")

var sensor_to_class = null
var sensor_descriptions = null

onready var globals = get_node('/root/Globals')

signal take_picture_button_pressed
signal drill_button_pressed
# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	globals.init_control_panel()
	$MarginContainer/Panel/SpecialsMenu.visible  = false
	update_elements_from_options()
	globals.connect("options_updated",self,"update_elements_from_options")

func update_elements_from_options():
	$MarginContainer/DebugTools.visible = globals.debug_mode

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if sensor_to_class != null:
		for i in range(min(len(sensor_to_class), len(hud_to_id))):
			var sclass = sensor_to_class[i]
			
			var hud = hud_to_id[i]
				
			var texture = sclass.render_view()
			if texture != null:
				_render_texture_to_hud(texture, hud)
			
			if sensor_descriptions != null:
				var sdesc = sensor_descriptions[i]
				hud.set_text(sdesc)

func set_sensor_classes(mapping):
	sensor_to_class = mapping
	
func set_sensor_descriptions(descrp):
	sensor_descriptions = descrp

func _render_texture_to_hud(texture, hud):
	var image = texture.get_data()
	var width = hud.rect_size[0]
	var height = hud.rect_size[1]
	image.resize(width, height)
	var itex = ImageTexture.new()
	itex.create_from_image(image)
	
	hud.set_render_target(itex)

func _on_toggle_background_button(button):
	var bg = $MarginContainer/Panel/Background
	bg.visible = button

func _on_ToggleHuds_toggled(button_pressed):
	$MarginContainer/Panel.visible = button_pressed

func _on_OpenSpecialsButton_pressed():
	$MarginContainer/Panel/SpecialsMenu.visible = !$MarginContainer/Panel/SpecialsMenu.visible

func _on_OpenBookButton_toggled(button_pressed):
	globals.set_book_visible(button_pressed)
	mark_read_book_icon(true)

func _on_TakeHighResPictureButton_pressed():
	emit_signal("take_picture_button_pressed")
	$MarginContainer/Panel/OpenSpecialsButton.emit_signal("pressed")
	$MarginContainer/Panel/OpenSpecialsButton.pressed = false
func _on_DrillSampleButton_pressed():
	emit_signal("drill_button_pressed")
	$MarginContainer/Panel/OpenSpecialsButton.emit_signal("pressed")
	$MarginContainer/Panel/OpenSpecialsButton.pressed = false
func mark_read_book_icon(read):
		book_btn.texture_normal =  book_read_texture if read else book_unread_texture
