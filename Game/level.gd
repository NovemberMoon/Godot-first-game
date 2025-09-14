extends Node2D


@onready var light = $DirectionalLight2D
@onready var time = $DayNight.wait_time
@onready var shopLight = $ShopLight
@onready var shopLight2 = $ShopLight2
@onready var dayText = $CanvasLayer/DayText
@onready var animPlayer = $CanvasLayer/AnimationPlayer


enum {
	MORNING,
	DAY,
	EVENING,
	NIGHT
}


var state = MORNING
var dayCount: int


func _ready() -> void:
	dayCount = 1
	set_day_text()
	day_text_fade()


func morning_state():
	var tween = get_tree().create_tween()
	tween.tween_property(light, "energy", 0.2, time)
	
	var tween2 = get_tree().create_tween()
	tween2.tween_property(shopLight, "energy", 0, time)
	
	var tween3 = get_tree().create_tween()
	tween3.tween_property(shopLight2, "energy", 0, time)


func evening_state():
	var tween = get_tree().create_tween()
	tween.tween_property(light, "energy", 0.95, time)
	
	var tween2 = get_tree().create_tween()
	tween2.tween_property(shopLight, "energy", 1.5, time)
	
	var tween3 = get_tree().create_tween()
	tween3.tween_property(shopLight2, "energy", 1.5, time)


func _on_day_night_timeout() -> void:
	match state:
		MORNING:
			morning_state()
		EVENING:
			evening_state()
	state = (state + 1) % 4
	if state == MORNING:
		dayCount += 1
		set_day_text()
		day_text_fade()


func day_text_fade():
	animPlayer.play("day_text_fade_in")
	await get_tree().create_timer(3).timeout
	animPlayer.play("day_text_fade_out")


func set_day_text():
	dayText.text = "DAY " + str(dayCount)
