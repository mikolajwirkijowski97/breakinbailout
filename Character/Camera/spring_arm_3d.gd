extends SpringArm3D
@export var follow_speed: int

var position_offset: Vector3

func _ready():
	position_offset = position
	top_level = true


func _physics_process(delta):
	position = get_parent().position + position_offset
