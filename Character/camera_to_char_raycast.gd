extends RayCast3D
signal object_occluding_char(object)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_main_character_main_char_position_updated(position):
	target_position = to_local(position)
	if is_colliding()
	pass # Replace with function body.
