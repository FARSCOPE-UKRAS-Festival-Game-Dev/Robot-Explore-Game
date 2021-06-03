extends Node

#Custom scripted sequences can go here

onready var globals = get_node('/root/Globals')

func shake_camera():

	#(duration = 0.2, frequency = 15, amplitude = 16, priority = 0):
	globals.robot.viewing_camera.get_node("CameraShaker").start(2, 15, 0.25, 0)
	
