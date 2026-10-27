extends Node
class_name GameState

var is_paused: bool = false
var can_pause: bool = true
var ready_timer: float = 0
var score: int = 0
var pellets: int = 0
var level_pellets_collected: int = 0
var enemies: int = 0
var level: int = 0
var lives: int = Constants.PLAYER_LIVES
var is_game_over: bool = false
var is_game_end: bool = false
var pacman_initial_pos: Vector2i = Vector2i(0, 0)
var is_fruit_spawned_1: bool = false
var is_fruit_spawned_2: bool = false
var fruit_timer: float = 0
var fruit_cell: Vector2i = Vector2i(0, 0)
var spawn_fruit_1_at: int = 0
var spawn_fruit_2_at: int = 0
