extends Node2D

@onready var anim_player: AnimationPlayer = $AnimationPlayer

var spell_range: float = 100
var min_distance: float = 50
var number_of_lightnings: int = 3
var damage: int = 20
var current_strike: int = 0
var player_pos = Global.player_pos
var direction = Global.player_direction

func _ready():
	Global.lightning_damage = damage
	_next_strike()

func _next_strike():
	if current_strike >= number_of_lightnings:
		await get_tree().create_timer(0.5).timeout
		queue_free()
		return
	
	var random_distance = randf() * (spell_range - min_distance) + min_distance
	var strike_x = player_pos.x + (direction * random_distance)
	position = Vector2(strike_x, player_pos.y - 25)
	
	anim_player.play("Strike")
	current_strike += 1
	
	await anim_player.animation_finished
	_next_strike()
