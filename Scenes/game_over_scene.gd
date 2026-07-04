extends SceneBase
class_name GameOverScene

func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("start") or Input.is_action_just_pressed("back_to_start"):
        game_intents.append(Game.Intent.START)
