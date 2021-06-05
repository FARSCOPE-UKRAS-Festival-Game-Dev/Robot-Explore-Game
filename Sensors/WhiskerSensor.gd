extends "BaseSensor.gd"

onready var bodies = []
onready var register = false
export onready var touching = [0, 0, 0, 0, 0, 0]

signal whisk_sense_new

func _ready():
	type = "whiskers"
	touching = [0, 0, 0, 0, 0, 0]

func _on_Area_body_entered(body):
	bodies.append(body)
	
	if not register:
		register = true
		bodies.clear()
		
	if register:
		emit_signal("whisk_sense_new")

func _on_Area_body_exited(body):
	if body in bodies:
		bodies.erase(body)

func render_view():
	if bodies.size() > 0:
		for c in bodies[0].get_children():
			if c.get_class() == "MeshInstance":
				if c.has_node("TactileInfo"):
					var texture = c.get_node("TactileInfo").value
					var itex = ImageTexture.new()
					itex.create_from_image(texture.get_data())		
					return itex
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

	return ""


func _on_Area_LM_body_entered(body):
	if body.name != "WhiskerSensor":
		touching[1] = 1


func _on_Area_LM_body_exited(body):
	if body.name != "WhiskerSensor":
		touching[1] = 0


func _on_Area_LT_body_entered(body):
	if body.name != "WhiskerSensor":
		touching[0] = 1


func _on_Area_LT_body_exited(body):
	if body.name != "WhiskerSensor":
		touching[0] = 0


func _on_Area_LB_body_entered(body):
	if body.name != "WhiskerSensor":
		touching[2] = 1


func _on_Area_LB_body_exited(body):
	if body.name != "WhiskerSensor":
		touching[2] = 0


func _on_Area_RM_body_entered(body):
	if body.name != "WhiskerSensor":
		touching[4] = 1


func _on_Area_RM_body_exited(body):
	if body.name != "WhiskerSensor":
		touching[4] = 0


func _on_Area_RT_body_entered(body):
	if body.name != "WhiskerSensor":
		touching[5] = 1


func _on_Area_RT_body_exited(body):
	if body.name != "WhiskerSensor":
		touching[5] = 0


func _on_Area_RB_body_entered(body):
	if body.name != "WhiskerSensor":
		touching[3] = 1


func _on_Area_RB_body_exited(body):
	if body.name != "WhiskerSensor":
		touching[3] = 0
