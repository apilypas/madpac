extends Node
class_name HudManager

@export var game_state: GameState
@export var level_label: Label
@export var score_label: Label
@export var lives_label: Label

var _last_score: int = -1
var _last_level: int = -1
var _last_lives: int = -1

func _process(_delta: float) -> void:
    if game_state.score != _last_score:
        _last_score = game_state.score
        score_label.text = "Score: %08d" % game_state.score
    if game_state.level != _last_level:
        _last_level = game_state.level
        level_label.text = "Level: %d" % game_state.level
    if game_state.lives != _last_lives:
        _last_lives = game_state.lives
        lives_label.text = "Lives: %d" % game_state.lives
