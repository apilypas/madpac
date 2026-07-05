extends CharacterBody2D
class_name Ghost

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var direction: Vector2 = Vector2.ZERO
var speed: float = 70.0
var scared_speed: float = 40.0
var is_spawned: bool = false
var scared_timer: float = 0
var is_moving: bool = true
var is_alive: bool = true
