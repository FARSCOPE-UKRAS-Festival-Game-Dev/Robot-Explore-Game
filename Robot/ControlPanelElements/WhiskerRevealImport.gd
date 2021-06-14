extends TextureRect

#tool
#
#export(bool) var re_import setget import
#
#func import(value):
#	if Engine.editor_hint:
#		for i in range(16):
#			self.texture.set_frame_texture(i,load("res://Assets/Images/whisker_reveal_overlay/reveal_sweep_%d.png"%i))
#		re_import = value
#		texture.current_frame = 15
#	print("imported!")
