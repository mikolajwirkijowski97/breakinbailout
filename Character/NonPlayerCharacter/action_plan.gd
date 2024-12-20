extends Node3D
class_name ActionPlan

var actions_array: Array

func _ready():
	for action in get_children():
		if action is not Action:
			continue
		actions_array.append(action)
		
func get_current_action():
	# TODO
	return actions_array[0]
