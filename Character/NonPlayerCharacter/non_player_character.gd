extends Character
class_name NonPlayerCharacter

@export var action_plan: ActionPlan
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D


func _ready():
	call_deferred("update_target_location")
	
func _on_busy_state_physics_processing(delta):
	var direction: Vector3 = (navigation_agent.get_next_path_position()\
	- global_position).normalized()
	
	velocity.x = direction.x * 10
	velocity.z = direction.z * 10

func update_target_location():
	var current_action: Action = action_plan.get_current_action()
	navigation_agent.target_position = current_action.global_position
	
