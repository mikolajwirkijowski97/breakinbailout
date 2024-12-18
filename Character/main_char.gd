extends CharacterBody3D
class_name MainChar

@onready var _state_chart: StateChart = $StateChart
@onready var _animation_tree: AnimationTree = $AnimationTree
@onready var _animation_state_machine: AnimationNodeStateMachinePlayback = _animation_tree.get("parameters/playback")
@export var spring_arm: SpringArm3D
@export var SPEED = 10.0
@export var call_handle_input: bool = true

signal main_char_position_updated(position)

# device doubles as player_id as it shares all the same properties
var device: int
var p_id: int = 0
var has_device: bool = false
var time_in_air = 0.0 

func _ready():
	PlayerDeviceManager.player_joined.connect(on_player_joined)
	PlayerDeviceManager.player_left.connect(on_player_left)
	print_debug("Im ready")

func _physics_process(delta):
	if(velocity):
		main_char_position_updated.emit(global_position)
	
	var dir_x: float = 0.0 if not has_device else MultiplayerInput.get_axis(device, "move_left","move_right") 
	var dir_z: float = 0.0 if not has_device else MultiplayerInput.get_axis(device, "move_backwards", "move_forward")
	
	var direction: Vector3 = Vector3(-dir_x, 0, dir_z).normalized()
	for i in 3:
		if direction[i]:
			velocity[i] = direction[i] * SPEED
		else:
			velocity[i] = move_toward(velocity[i], 0, SPEED)
	
	var min_velocity_rotation_cutoff: float = 0.2
	if velocity.length() > min_velocity_rotation_cutoff:
		var look_direction = Vector2(velocity.z, velocity.x)
		rotation.y = look_direction.angle()
	

	# Add to the midair timer
	if not is_on_floor():
		time_in_air += delta
	# handle the falling
	if is_falling():
		velocity += get_gravity() * 20.0 * delta

	move_and_slide()
	# let the state machine know if we are moving or not
	if is_zero_approx(velocity.x+velocity.z):
		_state_chart.send_event("idle")
	else:
		_state_chart.send_event("walk")

	# set the velocity to the animation tree, so it can blend between animations
	_animation_tree["parameters/Movement/blend_position"] = velocity.length() / SPEED - 1

func is_falling():
	return time_in_air > 0.15

func _process(delta):
	#spring_arm.position = position
	if call_handle_input:
		PlayerDeviceManager.handle_join_input()

func _on_idle_state_entered():
	pass

func _on_walk_state_entered():
	pass
	
func on_player_joined(_player):
	if _player == p_id and not has_device:
		print_debug("Device: "+str(_player)+" joined")
		has_device = true
		device = PlayerDeviceManager.get_player_device(_player)

func on_player_left(_player):
	print_debug("Device: "+str(_player)+" left")
	if _player == p_id:
		has_device = false
		



func _on_ledge_detector_bump_encountered():
	velocity.y += 15
