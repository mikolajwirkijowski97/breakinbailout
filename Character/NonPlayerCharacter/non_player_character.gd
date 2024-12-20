extends Character
class_name NonPlayerCharacter

@export var action_plan: ActionPlan
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
var SPEED: float = 2.

func _ready():
	_animation_tree = $AnimationTree
	call_deferred("get_next_terget_location")


func _physics_process(delta: float):
	# set the velocity in the animation tree, so it can blend between animations
	if _animation_tree:
		_animation_tree["parameters/Movement/blend_position"] = \
		velocity.length() / SPEED - 1

	move_and_slide()

func _on_busy_state_physics_processing(delta):
	var direction: Vector3 = (navigation_agent.get_next_path_position()\
	- global_position).normalized()

	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	
	if navigation_agent.is_target_reached():
		get_next_terget_location()

func get_next_terget_location():
	var current_action: Action = action_plan.get_next_action()
	navigation_agent.target_position = current_action.global_position
	
func _on_ledge_detector_bump_encountered():
	position.y += 0.04
