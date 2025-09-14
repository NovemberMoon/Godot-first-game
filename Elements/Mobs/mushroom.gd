extends CharacterBody2D


@onready var animPlayer = $AnimationPlayer


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()


func _on_attack_range_body_entered(body: Node2D) -> void:
	animPlayer.play("Attack")
