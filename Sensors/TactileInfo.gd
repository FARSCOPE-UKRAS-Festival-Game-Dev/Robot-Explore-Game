extends Node
tool 
enum material{
	Custom,
	InterestingRock,
	YetiShorts,
	YetiPainting,
	Water,
	Vines,
	RockType1,
	RobotPart,
	CaveWall,
	PlantSpecies1,
	PlantSpecies2,
	PlantSpecies3,
	PlantSpecies4,
	PlantSpecies5,
	Mushroom,
	Grass,
	Firewood
	
}
var material_dict = {
	material.InterestingRock : ["res://Assets/Models/Textures/Rock015_1K_Color.png", "Material X"],
	material.YetiShorts : ["res://Assets/Images/TactileInfoImages/YetiShorts.jpg", "Clothing?"],
	material.YetiPainting : ["res://Assets/Images/TactileInfoImages/YetiPainting.jpg", "Painting?"],
	material.Water : ["res://Assets/Models/Textures/Ice002_1K_Color.jpg", "Liquid"],
	material.Vines : ["res://Assets/Models/Terrain/Objects/VineWall/vineWallTex.jpg", "Vine"],
	material.RockType1 : ["res://Assets/Models/Textures/Rock008_1K_Color.jpg", "Granite"],
	material.CaveWall : ["res://Assets/Models/Textures/Rock008_1K_Color.jpg", "Granite"],
	material.RobotPart : ["res://Assets/Models/Textures/Robot/PaintedMetal007_1K_Color.jpg", "Titanium"],
	material.PlantSpecies1 : ["res://Assets/Images/TactileInfoImages/PlantSpecies1.jpg", "Plant Species 1"],
	material.PlantSpecies2 : ["res://Assets/Images/TactileInfoImages/PlantSpecies2.jpg", "Plant Species 2"],
	material.PlantSpecies3 : ["res://Assets/Images/TactileInfoImages/PlantSpecies3.jpg", "Plant Species 3"],
	material.PlantSpecies4 : ["res://Assets/Images/TactileInfoImages/PlantSpecies4.jpg", "Plant Species 1"],
	material.PlantSpecies5 : ["res://Assets/Images/TactileInfoImages/PlantSpecies5.jpg", "Plant Species 2"],
	material.Mushroom : ["res://Assets/Images/TactileInfoImages/Mushroom.jpg", "Mushroom"],
	material.Grass : ["res://Assets/Images/TactileInfoImages/Grass.jpg", "Grass"],
	material.Firewood : ["res://Assets/Images/TactileInfoImages/FireWood.jpg", "Burnt Wood"]
}

export(material) var type = material.Custom setget set_type
export(Texture) onready var value setget ,on_sense
export(String) var texture_name = ""

signal sensed_by_whiskers
func set_type(type_val):
	type = type_val
	if type != material.Custom:
		value = load(material_dict[type][0])
		texture_name = material_dict[type][1]
func _ready():
	if type != material.Custom:
		set_type(type)
func on_sense():

	emit_signal("sensed_by_whiskers")
	return value
