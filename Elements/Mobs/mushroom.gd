extends CharacterBody2D


@onready var animPlayer = $AnimationPlayer
@onready var sprite = $AnimatedSprite2D
@onready var attackDirection = $AttackDirection

enum {
	IDLE,
	ATTACK,
	CHASE,
	DAMAGE,
	DEATH,
	RECOVER
}

var state: int = IDLE:
	set(value):
		state = value
		match state:
			IDLE:
				idle_state()
			ATTACK:
				attack_state()
			DAMAGE:
				damage_state()
			DEATH:
				death_state()
			RECOVER:
				recover_state()

var direction
var damage = 20


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if state == CHASE:
		chase_state()
	
	move_and_slide()


func _on_attack_range_body_entered(_body: Node2D) -> void:
	state = ATTACK


func idle_state():
	animPlayer.play("Idle")
	state = CHASE


func attack_state():
	animPlayer.play("Attack")
	await animPlayer.animation_finished
	state = RECOVER


func chase_state():
	direction = (Global.player_pos - self.position).normalized()
	if direction.x < 0:
		sprite.flip_h = true
		attackDirection.rotation_degrees = 180
	else:
		sprite.flip_h = false
		attackDirection.rotation_degrees = 0


func damage_state():
	$AttackDirection/DamageBox/HitBox/CollisionShape2D.disabled = true
	damage_anim()
	animPlayer.play("Damage")
	await animPlayer.animation_finished
	state = IDLE


func death_state():
	Signals.emit_signal("enemy_died", position)
	animPlayer.play("Death")
	await animPlayer.animation_finished
	queue_free()


func recover_state():
	animPlayer.play("Recover")
	await animPlayer.animation_finished
	state = IDLE


func _on_hit_box_area_entered(_area: Area2D) -> void:
	Signals.emit_signal("enemy_attack", damage, self.position)


func _on_mob_health_no_health() -> void:
	state = DEATH


func _on_mob_health_damage_received() -> void:
	state = IDLE
	state = DAMAGE


func damage_anim():
	direction = (Global.player_pos - self.position).normalized()
	velocity.x = velocity.x + 200 if direction.x < 0 else velocity.x - 200
	var tween = get_tree().create_tween()
	tween.tween_property(self, "velocity", Vector2.ZERO, 0.1)
