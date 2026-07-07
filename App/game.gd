extends Node
class_name Game

enum Intent { START, PLAY, PAUSE, READY, GAME_OVER, GAME_END, POP }

@onready var scene_container: Node = $SceneContainer

@export var start_scene: PackedScene
@export var play_scene: PackedScene
@export var pause_scene: PackedScene
@export var ready_scene: PackedScene
@export var game_over_scene: PackedScene
@export var game_end_scene: PackedScene

var _intents: Array[SceneIntent] = []

func _ready() -> void:
    _open(start_scene)

func _process(_delta: float) -> void:
    while _intents.size() > 0:
        _handle_intent(_intents[0])
        _intents.remove_at(0)

func _handle_intent(i: SceneIntent) -> void:
    var type: = i.key
    if type == Intent.PAUSE:
        _push(pause_scene)
    elif type == Intent.READY:
        _push(ready_scene)
    elif type == Intent.GAME_OVER:
        _push(game_over_scene)
    elif type == Intent.POP:
        _pop()
    elif type == Intent.PLAY:
        _open(play_scene)
    elif type == Intent.START:
        _open(start_scene)
    elif type == Intent.GAME_END:
        _open(game_end_scene, i.data)

func _open(packed_scene: PackedScene, data: Dictionary = {}) -> void:
    for child in scene_container.get_children():
        child.queue_free()
    _push(packed_scene, data)

func _push(packed_scene: PackedScene, data: Dictionary = {}) -> void:
    var scene:SceneBase = packed_scene.instantiate()
    scene.game_intents = _intents
    scene.game_intent_data = data
    scene_container.add_child(scene)

func _pop() -> void:
    var child_count: = scene_container.get_child_count()
    if child_count > 0:
        var last: = scene_container.get_child(child_count - 1)
        last.queue_free()
