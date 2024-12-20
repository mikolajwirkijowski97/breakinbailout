extends Node3D
class_name ActionPlan

var actions_queue: Array

func _ready():
	for action in get_children():
		if action is not Action:
			continue
		actions_queue.append(action)
		
func get_next_action():
	var ret = actions_queue.pop_front()
	actions_queue.append(ret)
	return ret
	
