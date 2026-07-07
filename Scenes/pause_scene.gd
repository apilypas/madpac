extends SceneBase
class_name PauseScene

func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("pause"):
        queue_intent(Game.Intent.POP)
    if Input.is_action_just_pressed("back_to_start"):
        queue_intent(Game.Intent.START)
