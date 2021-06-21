extends Control

const CREDITS_FILE="res://Assets/credits.json"
#const FONT_FILE = preload("res://Fonts/")
const BUTTON_NORMAL  = preload("res://Assets/Images/Misc/down_arrow.png")
const BUTTON_PRESSED = preload("res://Assets/Images/Misc/down_arrow_pressed.png")

const section_time := 2.0
const line_time := 0.7
const base_speed := 120
const speed_up_multiplier := 10.0
const title_color := Color.khaki
const text_colour := Color.white
const normal_text_size := 50
const external_text_size := 30
var text_size = normal_text_size

var scroll_speed := base_speed
var speed_up := false

onready var line := $CreditsContainer/Line
var started := false
var finished := false

var section
var section_header := ''
var section_id := 0
var section_next := true
var section_timer := 0.0
var line_timer := 0.0
var curr_line := 0
var lines := []

var credits_json
var credits_order

func _ready():
	read_credits(CREDITS_FILE)

func read_credits(file_path):
	var file = File.new()
	
	file.open(file_path, File.READ)
	var JSON_result = JSON.parse(file.get_as_text())
	assert(JSON_result.error == OK, "Error loading JSON check format!")
	credits_json =  JSON_result.result
	credits_order = credits_json['order']
#	emit_signal("dialog_loaded")

func _process(delta):
	var scroll_speed = base_speed * delta
	
	if section_next:
		section_timer += delta * speed_up_multiplier if speed_up else delta
		if section_timer >= section_time:
			section_timer -= section_time
			
			if section_id < len(credits_order):
				started = true
#				section = credits.pop_front()
				section_header = credits_order[section_id]
				if 'External' in section_header:
					text_size = external_text_size
				else:
					text_size = normal_text_size
				section = [section_header.to_upper()] + credits_json[section_header]
				section_id += 1
				curr_line = 0
				add_line()
	
	else:
		line_timer += delta * speed_up_multiplier if speed_up else delta
		if line_timer >= line_time:
			line_timer -= line_time
			add_line()
	
	if speed_up:
		scroll_speed *= speed_up_multiplier
	
	if lines.size() > 0:
		for l in lines:
			l.rect_position.y -= scroll_speed
			if l.rect_position.y < -l.get_line_height():
				lines.erase(l)
				l.queue_free()
	elif started:
		finish()


func finish():
	if not finished:
		finished = true
		# NOTE: This is called when the credits finish
		# - Hook up your code to return to the relevant scene here, eg...
		#get_tree().change_scene("res://MainMenu.tscn")
		Globals.goto_scene("res://MainMenu.tscn")
func duplicate_line(_line):
	var new_line = _line.duplicate()
	var line_font = _line.get("custom_fonts/font")
	new_line.set("custom_fonts/font", line_font.duplicate())
	return new_line
	
func add_line():
	var new_line = duplicate_line(line)
	new_line.text = section.pop_front()
	lines.append(new_line)
	if curr_line == 0:
		new_line.add_color_override("font_color", title_color)
	else:
		new_line.get("custom_fonts/font").set_size(text_size)
		new_line.add_color_override("font_color", text_colour)
	$CreditsContainer.add_child(new_line)
	
	if section.size() > 0:
		curr_line += 1
		section_next = false
	else:
		section_next = true


func _unhandled_input(event):
	var action_list = ["ui_down", "ui_select", "ui_accept"]
	if event.is_action_pressed("ui_cancel"):
		finish()
	for a in action_list:
		if event.is_action_pressed(a) and !event.is_echo():
			$DownArrow.set_normal_texture(BUTTON_PRESSED)
			speed_up = true
		if event.is_action_released(a) and !event.is_echo():
			$DownArrow.set_normal_texture(BUTTON_NORMAL)
			speed_up = false

func _on_TextureRect_button_down():
	speed_up = true

func _on_TextureRect_button_up():
	speed_up = false
