extends Node3D

@export var player: Character
var time_in_air = 0.0 

func _physics_process(delta):
	# Right now assuming gravity always applies
	coyote_time_gravity(delta)
	
func should_be_falling():
	var coyote_time: float = 0.1
	return time_in_air > coyote_time
	
func coyote_time_gravity(delta: float):
	# Add to the midair timer
	if not player.is_on_floor():
		time_in_air += delta
	else:
		time_in_air = 0.0
	# handle the falling
	if should_be_falling():
		player.velocity += player.get_gravity() * 20.0 * delta
