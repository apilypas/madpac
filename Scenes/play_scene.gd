extends SceneBase
class_name PlayScene

@onready var game_state: GameState = $GameState

var _is_waiting_ready: bool = false
var _is_game_over_shown: bool = false

func _process(delta: float) -> void:
    if game_state.can_pause:
        if Input.is_action_just_pressed("pause"):
            game_state.is_paused = !game_state.is_paused
            if game_state.is_paused:
                game_intents.append(Game.Intent.PAUSE)

    if game_state.ready_timer > 0:
        if !_is_waiting_ready:
            _is_waiting_ready = true
            game_state.can_pause = false
            game_intents.append(Game.Intent.READY)
        game_state.ready_timer -= delta
        if game_state.ready_timer <= 0:
            game_intents.append(Game.Intent.POP)
            _is_waiting_ready = false
            game_state.can_pause = true
            game_state.is_paused = false

    if game_state.is_game_over and !_is_game_over_shown:
        _is_game_over_shown = true
        game_intents.append(Game.Intent.GAME_OVER)
