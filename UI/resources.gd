extends CanvasLayer


@onready var gold_count: Label = $Control/PanelContainer/HBoxContainer/GoldCount


func _process(_delta: float) -> void:
	gold_count.text = str(Global.gold)
