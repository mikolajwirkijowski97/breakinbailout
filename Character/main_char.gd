extends CharacterBody3D

@onready var _state_chart: StateChart = $StateChart
@onready var _animation_tree: AnimationTree = $AnimationTree
@onready var _animation_state_machine: AnimationNodeStateMachinePlayback = _animation_tree.get("parameters/playback")

@export var SPEED = 10.0

func _physics_process(delta):
	var dir_x = Input.get_axis("move_left","move_right")
	var dir_z = Input.get_axis("move_backwards", "move_forward")
	var direction = Vector3(dir_x, 0, dir_z)
	
	for i in 3:
		if direction[i]:
			velocity[i] = direction[i] * SPEED
		else:
			velocity[i] = move_toward(velocity[i], 0, SPEED)
			
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()
	
	# let the state machine know if we are moving or not
	if is_zero_approx(velocity.x+velocity.z):
		_state_chart.send_event("idle")
	else:
		_state_chart.send_event("walk")

	# set the velocity to the animation tree, so it can blend between animations
	_animation_tree["parameters/Movement/blend_position"] = velocity.length() / SPEED - 1


func _on_idle_state_entered():
	pass

func _on_walk_state_entered():
	pass
