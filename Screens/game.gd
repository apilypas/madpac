extends Node
class_name Game

enum Intent { PAUSE, UNPAUSE }

@export var scene_container: Node
@export var play_scene: PackedScene
@export var pause_scene: PackedScene

var _intents: Array[Intent] = []

func _ready() -> void:
    _open(play_scene)

func _process(_delta: float) -> void:
    while _intents.size() > 0:
        _handle_intent(_intents[0])
        _intents.remove_at(0)

func _handle_intent(intent: Intent) -> void:
    if intent == Intent.PAUSE:
        _push(pause_scene)
    elif intent == Intent.UNPAUSE:
        _pop()

func _open(packed_scene: PackedScene) -> void:
    for child in scene_container.get_children():
        child.queue_free()
    _push(packed_scene)

func _push(packed_scene: PackedScene) -> void:
    var scene:SceneBase = packed_scene.instantiate()
    scene.game_intents = _intents
    scene_container.add_child(scene)

func _pop() -> void:
    var child_count: = scene_container.get_child_count()
    if child_count > 0:
        var last: = scene_container.get_child(child_count - 1)
        last.queue_free()
