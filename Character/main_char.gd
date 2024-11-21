extends CharacterBody3D

@onready var animation_player: AnimationPlayer = $MainChar/AnimationPlayer


func _input(event):
	if event.is_action_pressed("ui_up"):
		$StateChart.send_event("walk")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()

func _on_idle_state_entered():
	animation_player.play("idle")
	
func _on_walk_state_entered():
	animation_player.play("walking")
