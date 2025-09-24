extends Node2D


@onready var mobs: Node2D = $".."
@onready var animation_player: AnimationPlayer = $AnimationPlayer

enum Enemies {
	MUSHROOM,
	SKELETON
}

var enemy
var enemy_name: int = Enemies.MUSHROOM:
	set(value):
		enemy_name = value
		match enemy_name:
			Enemies.MUSHROOM:
				enemy = mushroom_preload.instantiate()
			Enemies.SKELETON:
				enemy = skeleton_preload.instantiate()

var mushroom_preload = preload("res://Elements/Mobs/mushroom.tscn")
var skeleton_preload = preload("res://Elements/Mobs/skeleton.tscn")


func _ready() -> void:
	Signals.connect("day_time", Callable(self, "_on_time_changed"))


func enemy_spawn():
	enemy_name = randi_range(0, len(Enemies) - 1)
	enemy.position = Vector2(self.position.x + randi_range(-50, 50), 570)
	mobs.add_child(enemy)


func _on_time_changed(state):
	var rng = randi_range(0, 2)
	if state == 1:
		for i in (Global.day_count + rng): 
			animation_player.play("Spawn")
			await animation_player.animation_finished
		
		animation_player.play("Idle")
