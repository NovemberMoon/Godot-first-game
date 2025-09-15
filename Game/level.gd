extends Node2D


@onready var lightAnim = $Light/LightAnimation
@onready var textAnim = $CanvasLayer/TextAnimation
@onready var time = $Light/DayNight.wait_time
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
	healthBar.max_value = player.max_health
	healthBar.value = healthBar.max_value
	morning_state()


func morning_state():
	dayCount += 1
	dayText.text = "DAY " + str(dayCount)
	lightAnim.play("sunrise")
	textAnim.play("day_text_fade_in")
	await get_tree().create_timer(3).timeout
	textAnim.play("day_text_fade_out")


func evening_state():
	lightAnim.play("sunset")


func _on_day_night_timeout() -> void:
	state = (state + 1) % 4
	match state:
		MORNING:
			morning_state()
		EVENING:
			evening_state()


func _on_player_health_changed(new_health: Variant) -> void:
	healthBar.value = new_health
