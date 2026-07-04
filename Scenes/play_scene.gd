extends SceneBase
class_name PlayScene

@export var game_state: GameState

func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("pause"):
        game_state.is_paused = !game_state.is_paused
        if game_state.is_paused:
            game_intents.append(Game.Intent.PAUSE)
