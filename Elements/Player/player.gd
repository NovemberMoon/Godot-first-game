extends CharacterBody2D


enum {
	IDLE,
	MOVE,
	ATTACK,
	ATTACK2,
	ATTACK3,
	BLOCK,
	SLIDE,
	DAMAGE,
	DEATH
}

const SPEED = 150.0
const JUMP_VELOCITY = -400.0

@onready var anim = $AnimatedSprite2D
@onready var animPlayer = $AnimationPlayer
@onready var attackDirection = $AttackDirection
@onready var stats = $Stats

var gold = 0
var state = MOVE
var run_speed = 1
var combo = false
var attack_cooldown = false
var damage_basic = 10
var damage_multiplier = 1
var recovery = false


func _ready() -> void:
	Signals.connect("enemy_attack", Callable(self, "_on_damage_received"))


func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta
	
	Global.player_damage = damage_basic * damage_multiplier
	Global.player_pos = self.position
	
	set_state()
	move_and_slide()


func set_state():
	match state:
			MOVE:
				move_state()
			ATTACK:
				attack_state()
			ATTACK2:
				attack2_state()
			ATTACK3:
				attack3_state()
			BLOCK:
				block_state()
			SLIDE:
				slide_state()
			DAMAGE:
				damage_state()
			DEATH:
				death_state()


func move_state():
	
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED * run_speed
		if velocity.y == 0:
			if run_speed == 1:
				animPlayer.play("Walk")
			else:
				animPlayer.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			animPlayer.play("Idle")
	
	if direction == -1:
		anim.flip_h = true
		attackDirection.rotation_degrees = 180
	elif direction == 1:
		anim.flip_h = false
		attackDirection.rotation_degrees = 0
		
	if Input.is_action_pressed("run") and !recovery:
		stats.stamina -= stats.run_cost
		run_speed = 1.5
	else:
		run_speed = 1
	
	if Input.is_action_just_pressed("block") and velocity.x != 0 and !recovery:
		stats.stamina_cost = stats.slide_cost
		if stats.stamina_cost <= stats.stamina:
			state = SLIDE
	elif Input.is_action_pressed("block") and velocity.x == 0 and !recovery:
		if stats.stamina >= stats.block_cost:
			state = BLOCK
			
	if Input.is_action_just_pressed("attack") and !attack_cooldown and !recovery:
		stats.stamina_cost = stats.attack_cost
		if stats.stamina_cost <= stats.stamina:
			state = ATTACK


func block_state():
	stats.stamina -= stats.block_cost
	velocity.x = 0
	animPlayer.play("Block")
	if Input.is_action_just_released("block") or recovery:
		state = MOVE


func slide_state():
	animPlayer.play("Slide")
	await animPlayer.animation_finished
	state = MOVE


func attack_state():
	stats.stamina_cost = stats.attack_cost
	damage_multiplier = 1
	if Input.is_action_just_pressed("attack") and combo and stats.stamina_cost <= stats.stamina:
		state = ATTACK2
	velocity.x = 0
	animPlayer.play("Attack")
	await animPlayer.animation_finished
	attack_freeze()
	state = MOVE


func attack2_state():
	stats.stamina_cost = stats.attack_cost
	damage_multiplier = 1.2
	if Input.is_action_just_pressed("attack") and combo and stats.stamina_cost <= stats.stamina:
		state = ATTACK3
	animPlayer.play("Attack2")
	await animPlayer.animation_finished
	state = MOVE


func attack3_state():
	damage_multiplier = 2
	animPlayer.play("Attack3")
	await animPlayer.animation_finished
	state = MOVE


func combo1():
	combo = true
	await animPlayer.animation_finished
	combo = false


func attack_freeze():
	attack_cooldown = true
	await get_tree().create_timer(0.5).timeout
	attack_cooldown = false


func damage_state():
	$AttackDirection/DamageBox/HitBox/CollisionShape2D.disabled = true
	animPlayer.play("Damage")
	await animPlayer.animation_finished
	state = MOVE


func death_state():
	$AttackDirection/DamageBox/HitBox/CollisionShape2D.disabled = true
	velocity.x = 0
	animPlayer.play("Death")
	await animPlayer.animation_finished
	queue_free()
	get_tree().change_scene_to_file.bind("res://UI/menu.tscn").call_deferred()


func _on_damage_received(enemy_damage, enemy_position):
	if state == BLOCK:
		enemy_damage /= 2
	elif state == SLIDE:
		enemy_damage = 0
	else:
		state = DAMAGE
		damage_anim(enemy_position)
	
	stats.health -= enemy_damage
	if stats.health == 0:
		stats.health = 0
		state = DEATH


func _on_stats_no_stamina() -> void:
	recovery = true
	await get_tree().create_timer(2).timeout
	recovery = false


func damage_anim(enemy_position):
	var direction = (Global.player_pos - enemy_position).normalized()
	velocity.x = 0
	self.modulate = Color(1, 0, 0, 1)
	velocity.x = velocity.x + 200 if direction.x > 0 else velocity.x - 200
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(self, "velocity", Vector2.ZERO, 0.1)
	tween.parallel().tween_property(self, "modulate", Color(1, 1, 1, 1), 0.1)
