extends "BaseSensor.gd"

onready var bodies = []
onready var register = false

signal whisk_sense_new

func _ready():
	type = "whiskers"

func _on_Area_body_entered(body):
	bodies.append(body)
	
	if not register and bodies.size() == 2:
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
