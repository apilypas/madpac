extends Node
class_name DeathSystem

var level: Level

var _spawn_position: Vector2
var _ghost_positions: Array[Vector2] = []
var _ghost_spawn_timer: float = 5.0

func _ready() -> void:
    _spawn_position = level.pacman.position
    for ghost in level.ghosts:
        _ghost_positions.append(ghost.position)

func _process(delta: float) -> void:
    for ghost in level.ghosts:
        if ghost.position.distance_to(level.pacman.position) < 16:
            if ghost.scared_timer > 0:
                ghost.position = _ghost_positions.pick_random()
                ghost.scared_timer = 0
                ghost.is_spawned = false
            else:
                level.pacman.position = _spawn_position

    _handle_ghost_spawning(delta)

func _handle_ghost_spawning(delta: float) -> void:
    _ghost_spawn_timer -= delta
    if _ghost_spawn_timer <= 0:
        _ghost_spawn_timer += 5.0
        for ghost in level.ghosts:
            if !ghost.is_spawned:
                ghost.is_spawned = true
                ghost.is_moving = false
                var tween: = create_tween()
                tween.tween_property(ghost, "scale", Vector2(0, 0), 0.2)
                tween.tween_property(ghost, "position", level.ghost_spawn_marker.position, 0)
                tween.tween_property(ghost, "scale", Vector2(1, 1), 0.2)
                tween.tween_property(ghost, "is_moving", true, 0)
                break # Spawn only one ghost at once
