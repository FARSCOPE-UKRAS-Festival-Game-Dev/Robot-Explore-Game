extends "BaseSensor.gd"

onready var bodies = []
onready var register = false
export var enabled = true
export onready var touching = [0, 0, 0, 0, 0, 0]

signal whisker_sense_new
signal whisker_sense_none
signal touching_changed

onready var sense_area = $SensorWhiskers/SenseArea

func _ready():
	type = "whiskers"
	touching = [0, 0, 0, 0, 0, 0]
	var old_enabled = enabled
	enabled = false
	
	yield(get_tree().create_timer(0.1),"timeout")
	bodies.clear()
	enabled = old_enabled
func _on_Area_body_entered(body):
	bodies.append(body)
	
	if not register:
		register = true
		bodies.clear()
		
	if register and enabled:
		emit_signal("whisker_sense_new")

func _on_Area_body_exited(body):
	if body in bodies:
		bodies.erase(body)
		if bodies.empty():
			emit_signal("whisker_sense_none")
func render_view():
	if bodies.size() > 0:
		for c in bodies[0].get_children():
			if c.get_class() == "MeshInstance":
				if c.has_node("TactileInfo"):
					var texture = c.get_node("TactileInfo").value
					return texture
				else:
					var texture = c.get_active_material(0).get_texture(0)
					if texture != null:
						return texture

	var image = Image.new()
	image.create(360,360,false,Image.FORMAT_RGB8)
	image.fill(Color(1, 1, 1, 1))
	var itex = ImageTexture.new()
	itex.create_from_image(image)
	return itex

func render_text():
	if bodies.size() > 0:
		for c in bodies[0].get_children():
			if c.get_class() == "MeshInstance":
				if c.has_node("TactileInfo"):
					return c.get_node("TactileInfo").texture_name

	return "Unknown"


func _on_Area_LM_body_entered(body):
	if body.name != "WhiskerSensor":
		touching[1] = 1
		if enabled:
			emit_signal("touching_changed")

func _on_Area_LM_body_exited(body):
	if body.name != "WhiskerSensor":
		touching[1] = 0
		if enabled:
			emit_signal("touching_changed")

func _on_Area_LT_body_entered(body):
	if body.name != "WhiskerSensor":
		touching[0] = 1
		if enabled:
			emit_signal("touching_changed")

func _on_Area_LT_body_exited(body):
	if body.name != "WhiskerSensor":
		touching[0] = 0
		if enabled:
			emit_signal("touching_changed")
			
func _on_Area_LB_body_entered(body):
	if body.name != "WhiskerSensor":
		touching[2] = 1
		if enabled:
			emit_signal("touching_changed")

func _on_Area_LB_body_exited(body):
	if body.name != "WhiskerSensor":
		touching[2] = 0
		if enabled:
			emit_signal("touching_changed")

func _on_Area_RM_body_entered(body):
	if body.name != "WhiskerSensor":
		touching[4] = 1
		if enabled:
			emit_signal("touching_changed")

func _on_Area_RM_body_exited(body):
	if body.name != "WhiskerSensor":
		touching[4] = 0
		if enabled:
			emit_signal("touching_changed")

func _on_Area_RT_body_entered(body):
	if body.name != "WhiskerSensor":
		touching[5] = 1
		if enabled:
			emit_signal("touching_changed")
			
func _on_Area_RT_body_exited(body):
	if body.name != "WhiskerSensor":
		touching[5] = 0
		if enabled:
			emit_signal("touching_changed")
func _on_Area_RB_body_entered(body):
	if body.name != "WhiskerSensor":
		touching[3] = 1
		if enabled:
			emit_signal("touching_changed")
			
func _on_Area_RB_body_exited(body):
	if body.name != "WhiskerSensor":
		touching[3] = 0
		if enabled:
			emit_signal("touching_changed")
