extends CharacterBody2D


const SPEED = 100.0

var chase = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	var player = $"../../Player/Player"
	var direction = (player.position - self.position).normalized()
	
	if chase:
		velocity.x = direction.x * SPEED
	else:
		velocity.x = 0.0
		
	move_and_slide()


func _on_detector_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		chase = true


func _on_detector_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		chase = false
