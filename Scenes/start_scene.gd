extends SceneBase
class_name StartScene

@onready var start_label: Label = $UI/Control/StartLabel
@onready var sfx_player: SfxPlayer = $SfxPlayer

var _flicker_timer: float = 0
var _flicker_intensity: float = 0.7

func _process(delta: float) -> void:
    if Input.is_action_just_pressed("start"):
        sfx_player.play(Audio.Sfx.BONUS)
        start_label.visible = true
        _flicker_intensity = 0.1
        _flicker_timer = _flicker_intensity
        await get_tree().create_timer(1.0).timeout
        queue_intent(Game.Intent.PLAY)

    _flicker_timer -= delta

    if _flicker_timer <= 0:
        _flicker_timer += _flicker_intensity
        start_label.visible = !start_label.visible
