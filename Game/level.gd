extends Node2D


@onready var lightAnim = $Light/LightAnimation
@onready var dayText = $CanvasLayer/DayText
@onready var healthBar = $CanvasLayer/HealthBar
@onready var player = $Player/Player


enum {
	MORNING,
	DAY,
	EVENING,
	NIGHT
}


var state = MORNING
var dayCount = 0


func _ready() -> void:
	morning_state()
	healthBar.value = Global.player_health


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


func _on_player_health_changed() -> void:
	healthBar.value = Global.player_health
