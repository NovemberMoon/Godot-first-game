extends Node2D


@onready var lightAnim = $Light/LightAnimation
@onready var dayText = $CanvasLayer/DayText
@onready var player = $Player/Player

enum {
	MORNING,
	DAY,
	EVENING,
	NIGHT
}


var state:int = MORNING


func _ready() -> void:
	Global.gold = 0
	morning_state()


func morning_state():
	Global.day_count += 1
	dayText.text = "DAY " + str(Global.day_count)
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
	Signals.emit_signal("day_time", state)
