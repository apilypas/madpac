extends SceneBase
class_name EndScene

@onready var _score_label: Label = $UI/Control/ScoreLabel
@onready var _pellets_label: Label = $UI/Control/PelletsLabel
@onready var _enemies_label: Label = $UI/Control/EnemiesLabel

func _ready() -> void:
    _score_label.text = str(game_intent_data["score"])
    _pellets_label.text = str(game_intent_data["pellets"])
    _enemies_label.text = str(game_intent_data["enemies"])
