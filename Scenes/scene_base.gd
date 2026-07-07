extends Node2D
class_name SceneBase

var game_intents: Array[SceneIntent]
var game_intent_data: Dictionary = {}

func queue_intent(intent: Game.Intent, data: Dictionary = {}) -> void:
    var i: = SceneIntent.new()
    i.key = intent
    i.data = data
    game_intents.append(i)
