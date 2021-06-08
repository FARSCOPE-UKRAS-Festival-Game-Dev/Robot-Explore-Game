extends Node



var drill_fail_counter = 0
func _ready():
	Globals.load_dialog_from_file("res://Assets/Dialog/dialog_testing_JSON.json")



func failed_drill(action):
	if action != 2:
		drill_fail_counter+=1
		print("drill fail count %d" % drill_fail_counter)
	if drill_fail_counter > 5:
		var hint  = $Mission1/ObjectiveSingle2/Hint2
		hint.show_hint()


func _on_ObjectiveSingle2_on_objective_complete(ObjectiveBase):
	Globals.robot.disconnect("on_fail_action",self,"failed_drill")


func _on_ObjectiveSingle_on_objective_complete(ObjectiveBase):
	Globals.robot.connect("on_fail_action",self,"failed_drill")
	print("drill failed")
