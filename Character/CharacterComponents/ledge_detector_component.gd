extends Node3D
signal bump_encountered()

@export var upper_bound : float
@export var lower_bound : float
@export var upper_range : float
@export var lower_range : float

func _ready():
	$TestHigherCollision.position.y = upper_bound
	$TestHigherCollision.target_position.z = upper_range

	$TestLowerCollision.position.y = lower_bound
	$TestLowerCollision.target_position.z = lower_range

func _physics_process(delta):
	var lower_test = $TestLowerCollision.is_colliding()
	var higher_test = $TestHigherCollision.is_colliding()

	if lower_test and not higher_test:
		print("Bump encountered beforemath")
		bump_encountered.emit()
