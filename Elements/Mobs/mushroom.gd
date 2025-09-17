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

var player
var direction
var damage = 20


func _ready() -> void:
	Signals.connect("player_position_update", Callable(self, "_on_player_position_update"))


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if state == CHASE:
		chase_state()
	
	move_and_slide()


func _on_player_position_update(player_pos):
	player = player_pos


func _on_attack_range_body_entered(body: Node2D) -> void:
	state = ATTACK


func idle_state():
	animPlayer.play("Idle")
	state = CHASE


func attack_state():
	animPlayer.play("Attack")
	await animPlayer.animation_finished
	state = RECOVER


func chase_state():
	direction = (player - self.position).normalized()
	if direction.x < 0:
		sprite.flip_h = true
		attackDirection.rotation_degrees = 180
	else:
		sprite.flip_h = false
		attackDirection.rotation_degrees = 0

func damage_state():
	animPlayer.play("Damage")
	await animPlayer.animation_finished
	state = IDLE


func death_state():
	animPlayer.play("Death")
	await animPlayer.animation_finished
	queue_free()


func recover_state():
	animPlayer.play("Recover")
	await animPlayer.animation_finished
	state = IDLE


func _on_hit_box_area_entered(area: Area2D) -> void:
	Signals.emit_signal("enemy_attack", damage)


func _on_mob_health_no_health() -> void:
	state = DEATH


func _on_mob_health_damage_received() -> void:
	state = IDLE
	state = DAMAGE
