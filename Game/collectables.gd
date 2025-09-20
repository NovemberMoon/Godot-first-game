extends Node2D


var coin_preload = preload("res://Elements/Collectables/coin.tscn") 


func _ready() -> void:
	Signals.connect("enemy_died", Callable(self, "_on_enemy_died"))


func _on_enemy_died(enemy_position) -> void:
	for i in randi_range(1, 5):
		spawn_coin(enemy_position)
		await get_tree().create_timer(0.05).timeout


func spawn_coin(pos):
	var coin = coin_preload.instantiate()
	coin.position = pos
	add_child(coin)
 
