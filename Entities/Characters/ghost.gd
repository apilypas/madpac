extends CharacterBody2D
class_name Ghost

@export var sprite: AnimatedSprite2D

var direction: Vector2 = Vector2.ZERO
var speed: float = 30.0
var is_spawned: bool = false
var scared_timer: float = 0
var is_moving: bool = true
