extends Node2D


signal no_health()
signal damage_received()

@onready var health_bar = $HealthBar
@onready var damage_text = $DamageText
@onready var anim_player = $AnimationPlayer

var player_dmg
@export var max_health = 100

var health = 100:
	set(value):
		health = value
		health_bar.value = health
		if health <= 0:
			health_bar.visible = false
		else:
			health_bar.visible = true

func _ready() -> void:
	health_bar.max_value = max_health
	health = max_health
	health_bar.visible = false
	damage_text.modulate.a = 0


func _on_hurt_box_area_entered(area: Area2D) -> void:
	await get_tree().create_timer(0.05).timeout
	var damage
	if area.name == "HitBox":
		damage = Global.player_damage
	elif area.name == "LightningArea":
		damage = Global.lightning_damage
	health -= damage
	damage_text.text = str(int(damage))
	anim_player.stop()
	anim_player.play("damage_text")
	if health <= 0:
		emit_signal("no_health")
	else:
		emit_signal("damage_received")
