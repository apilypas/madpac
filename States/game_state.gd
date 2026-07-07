extends Node
class_name GameState

var is_paused: bool = false
var can_pause: bool = true
var ready_timer: float = 0
var score: int = 0
var pellets: int = 0
var enemies: int = 0
var level: int = 0
var lives: int = Constants.PLAYER_LIVES
var is_game_over: bool = false
var is_game_end: bool = false
