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
	PlantSpeciesA,
	PlantSpeciesB,
	PlantSpeciesC,
	PlantSpeciesD,
	PlantSpeciesE,
	Mushroom,
	Grass,
	Firewood
	
}
var material_dict = {
	material.InterestingRock : ["res://Assets/Models/Textures/Rock015_1K_Color.png", "Material X"],
	material.YetiShorts : ["res://Assets/Models/Terrain/Objects/1024px-Polka_dots.svg.png", "Clothing?"],
	material.YetiPainting : ["res://Assets/Models/Textures/Rock008_1K_Color.jpg", "Painting?"], #Do we need a separate asset for this?
	material.Water : ["res://Assets/Models/Textures/Ice002_1K_Color.jpg", "Liquid"],
	material.Vines : ["res://Assets/Models/Terrain/Objects/VineWall/vineWallTex.jpg", "Vine"],
	material.RockType1 : ["res://Assets/Models/Textures/Rock008_1K_Color.jpg", "Granite"],
	material.CaveWall : ["res://Assets/Models/Textures/Rock008_1K_Color.jpg", "Granite"],
	material.RobotPart : ["res://Assets/Models/Textures/Robot/PaintedMetal007_1K_Color.jpg", "Titanium"],
	material.PlantSpeciesA : ["res://Assets/Images/TactileInfoImages/PlantSpeciesA.jpg", "Indirhops afluentipes"],
	material.PlantSpeciesB : ["res://Assets/Images/TactileInfoImages/PlantSpeciesB.jpg", "Xerorhops psaroscapus"],
	material.PlantSpeciesC : ["res://Assets/Images/TactileInfoImages/PlantSpeciesC.jpg", "Argentrhops culumpomus"],
	material.PlantSpeciesD : ["res://Assets/Images/TactileInfoImages/PlantSpeciesD.jpg", "Solariphytum mairies"],
	material.PlantSpeciesE : ["res://Assets/Images/TactileInfoImages/PlantSpeciesE.jpg", "Undulatphytum anthemis"],
	material.Mushroom : ["res://Assets/Images/TactileInfoImages/Mushroom.jpg", "Mushroom"],
	material.Grass : ["res://Assets/Images/TactileInfoImages/Grass.jpg", "Grass"], #NOT implimented
	material.Firewood : ["res://Assets/Images/TactileInfoImages/FireWood.jpg", "Burnt Wood"]#NOT implimented
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
