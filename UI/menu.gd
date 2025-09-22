extends Node2D


@onready var btn_sound: AudioStreamPlayer = $BtnSound


func _on_btn_quit_pressed() -> void:
	btn_sound.play()
	await btn_sound.finished
	get_tree().quit()


func _on_btn_play_pressed() -> void:
	btn_sound.play()
	await btn_sound.finished
	get_tree().change_scene_to_file("res://Game/level.tscn")
