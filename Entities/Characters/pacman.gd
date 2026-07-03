extends CharacterBody2D
class_name Pacman

@export var sprite: AnimatedSprite2D

var speed: float = 60.0
var direction: Vector2 = Vector2.ZERO
var future_direction: Vector2 = Vector2.ZERO
var future_direction_timer: float = 0.0
var last_position: Vector2 = Vector2.ZERO
var ignore_input_timer: float = 0
