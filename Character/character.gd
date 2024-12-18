extends CharacterBody3D
class_name Character

@onready var _state_chart: StateChart = $StateChart
@onready var _animation_tree: AnimationTree = $AnimationTree
@onready var _animation_state_machine: AnimationNodeStateMachinePlayback = _animation_tree.get("parameters/playback")
@export var spring_arm: SpringArm3D
@export var call_handle_input: bool = true

signal main_char_position_updated(position)

var time_in_air = 0.0 

func _physics_process(delta):
	if(velocity):
		main_char_position_updated.emit(global_position)
	# Add to the midair timer
	if not is_on_floor():
		time_in_air += delta
	# handle the falling
	if is_falling():
		velocity += get_gravity() * 20.0 * delta

	move_and_slide()

	

func is_falling():
	return time_in_air > 0.15

func _process(delta):
	if call_handle_input:
		PlayerDeviceManager.handle_join_input()

func _on_idle_state_entered():
	pass

func _on_walk_state_entered():
	pass

func _on_ledge_detector_bump_encountered():
	velocity.y += 15
