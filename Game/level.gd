extends Node2D


@onready var light = $DirectionalLight2D
@onready var time = $DayNight.wait_time
@onready var shopLight = $ShopLight
@onready var shopLight2 = $ShopLight2


enum {
	MORNING,
	DAY,
	EVENING,
	NIGHT
}


var state = MORNING


func _ready() -> void:
	light.enabled = true


func _process(delta: float) -> void:
	match state:
		MORNING:
			morning_state()
		EVENING:
			evening_state()
	


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
	state = (state + 1) % 4
