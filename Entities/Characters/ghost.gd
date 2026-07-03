extends CharacterBody2D
class_name Ghost

var direction: Vector2 = Vector2.ZERO
var speed: float = 30.0
var is_spawned: bool = false
var sprite: AnimatedSprite2D
var scared_timer: float = 0

func _ready() -> void:
    sprite = get_node("AnimatedSprite2D")
