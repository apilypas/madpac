extends Node2D
class_name PointsLabel

@onready var _label: Label = $Label

var _timer: float = 2.0

func _process(delta: float) -> void:
    _timer -= delta
    if _timer <= 0:
        queue_free()

func set_text(text: String) -> void:
    _label.text = text
