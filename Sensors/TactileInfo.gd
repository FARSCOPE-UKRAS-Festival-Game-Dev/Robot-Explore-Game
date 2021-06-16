extends Node
tool 
enum material{
	InterestingRock,
	YetiShorts,
	YetiPainting,
	Water,
	Vines,
	RockType1,
	RobotPart,
	PlantSpecies1,
	PlantSpecies2,
	PlantSpecies3,
	Custom
}
var material_dict = {
	0 : ["InterestingRock.jpg", "Material X"],
	1 : ["YetiShorts.jpg", "Clothing?"],
	2 : ["YetiPainting.jpg", "Painting?"],
	3 : ["Water.jpg", "H20"],
	4 : ["Vines.jpg", "Vine"],
	5 : ["RockType1.jpg", "Granite"],
	6 : ["RobotPart.jpg", "Titanium"],
	7 : ["PlantSpecies1.jpg", "Plant Species 1"],
	8 : ["PlantSpecies2.jpg", "Plant Species 2"],
	9 : ["PlantSpecies3.jpg", "Plant Species 3"]
}

export(material) var type = material.Custom setget set_type
export(Texture) onready var value = load("res://Assets/Models/Textures/Rock015_1K_Color.png") setget ,on_sense
export(String) var texture_name = "Test"

signal sensed_by_whiskers
func set_type(type_val):
	type = type_val
	if type != material.Custom:
		value = load("res://Assets/Images/TactileInfoImages/"+material_dict[type][0])
		texture_name = material_dict[type][1]

func on_sense():
	emit_signal("sensed_by_whiskers")
	return value
