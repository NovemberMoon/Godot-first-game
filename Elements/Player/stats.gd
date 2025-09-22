extends CanvasLayer

signal no_stamina()

@onready var health_bar = $HealthBar
@onready var stamina_bar = $Stamina
@onready var changing_health_text = $"../ChangingHealth/ChangingHealthText"
@onready var changing_health_anim = $"../ChangingHealth/ChangingHealthAnimation"

var stamina_cost
var attack_cost = 10
var block_cost = 0.5
var slide_cost = 20
var run_cost = 0.3

var max_health = 120
var old_health = max_health
var health:
	set(value):
		health = clamp(value, 0, max_health)
		health_bar.value = health
		var health_diff = health - old_health
		old_health = health
		changing_health_text.text = str(health_diff)
		if health_diff > 0:
			changing_health_anim.play("Health_received")
		elif health_diff < 0:
			changing_health_anim.play("Damage_received")

var stamina = 50:
	set(value):
		stamina = value
		stamina_bar.value = stamina
		if stamina < block_cost:
			emit_signal("no_stamina")

func _ready() -> void:
	changing_health_text.modulate.a = 0
	health = max_health
	health_bar.max_value = health
	health_bar.value = health


func _process(delta: float) -> void:
	if stamina < 100:
		stamina += 10 * delta


func stamina_consumption():
	stamina -= stamina_cost


func _on_health_regen_timeout() -> void:
	health += 1


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("attack") and stamina > attack_cost:
		stamina -= attack_cost
	
