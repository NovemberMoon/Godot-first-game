extends Node2D


@onready var lightAnim = $Light/LightAnimation
@onready var dayText = $CanvasLayer/DayText
@onready var player = $Player/Player

var mushroom_preload = preload("res://Elements/Mobs/mushroom.tscn")

enum {
	MORNING,
	DAY,
	EVENING,
	NIGHT
}


var state:int = MORNING
var dayCount = 0


func _ready() -> void:
	Global.gold = 0
	morning_state()


func morning_state():
	dayCount += 1
	dayText.text = "DAY " + str(dayCount)
	lightAnim.play("sunrise")
	await get_tree().create_timer(3).timeout


func evening_state():
	lightAnim.play("sunset")


func _on_day_night_timeout() -> void:
	state = (state + 1) % 4
	match state:
		MORNING:
			morning_state()
		EVENING:
			evening_state()


func _on_spawner_timeout() -> void:
	mushroom_spawn()


func mushroom_spawn():
	var mushroom = mushroom_preload.instantiate()
	mushroom.position = Vector2(randi_range(-500, -200), 570)
	$Mobs.add_child(mushroom)
