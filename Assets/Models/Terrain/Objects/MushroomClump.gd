extends Spatial

tool 

export(Color) var mushroom_colour setget set_mushroom_colour
export(float) var light_range = 5.0 setget set_light_range

func set_mushroom_colour(value):
	mushroom_colour = value
	$OmniLight.light_color = mushroom_colour
func set_light_range(value):
	light_range = value
	$OmniLight.omni_range = value
