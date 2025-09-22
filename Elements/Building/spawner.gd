extends Node2D


@onready var mobs: Node2D = $".."
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var mushroom_preload = preload("res://Elements/Mobs/mushroom.tscn")


func _ready() -> void:
	Signals.connect("day_time", Callable(self, "_on_time_changed"))


func mushroom_spawn():
	var mushroom = mushroom_preload.instantiate()
	mushroom.position = Vector2(self.position.x + randi_range(-50, 50), 570)
	mobs.add_child(mushroom)


func _on_time_changed(state):
	var rng = randi_range(0, 2)
	if state == 1:
		for i in (Global.day_count + rng): 
			animation_player.play("Spawn")
			await animation_player.animation_finished
		
		animation_player.play("Idle")
