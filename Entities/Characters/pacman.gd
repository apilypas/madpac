extends CharacterBody2D
class_name Pacman

@export var sprite: AnimatedSprite2D

var speed: float = 120.0
var direction: Vector2 = Vector2.ZERO
var future_direction: Vector2 = Vector2.ZERO
var future_direction_timer: float = 0.0
var last_position: Vector2 = Vector2.ZERO
var ignore_input_timer: float = 0
var is_moving: bool = true
var is_alive: bool = true
