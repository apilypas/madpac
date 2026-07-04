extends SceneBase

func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("start"):
        game_intents.append(Game.Intent.PLAY)
