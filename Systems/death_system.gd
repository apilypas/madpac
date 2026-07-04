extends Node
class_name DeathSystem

@export var game_state: GameState

var level: Level

var _spawn_position: Vector2
var _ghost_positions: Array[Vector2] = []
var _ghost_spawn_timer: float = 5.0
var _hit_stop_timer: float = 0

func _ready() -> void:
    _spawn_position = level.pacman.position
    for ghost in level.ghosts:
        _ghost_positions.append(ghost.position)

func _process(delta: float) -> void:
    if game_state.is_paused:
        return

    for ghost in level.ghosts:
        if ghost.is_alive and ghost.position.distance_to(level.pacman.position) < 16:
            if ghost.scared_timer > 0:
                ghost.scared_timer = 0
                ghost.is_spawned = false
                ghost.is_alive = false
                _hit_stop_timer = 0.2
                var tween: = create_tween()
                tween.tween_property(ghost, "position", _ghost_positions.pick_random(), 0.3)
                tween.tween_property(ghost, "is_alive", true, 0)
                game_state.score += 500
            else:
                level.pacman.position = _spawn_position
                level.pacman.direction = Vector2.ZERO
                _ghost_spawn_timer = 5.0
                for g in level.ghosts:
                    g.position = _ghost_positions.pick_random()
                    g.is_spawned = false
                    g.scared_timer = 0

    _handle_ghost_spawning(delta)
    _handle_hit_stop(delta)

func _handle_hit_stop(delta: float) -> void:
    if _hit_stop_timer > 0:
        _hit_stop_timer -= delta
        if _hit_stop_timer > 0:
            for ghost in level.ghosts:
                ghost.is_moving = false
            level.pacman.is_moving = false
        else :
            for ghost in level.ghosts:
                ghost.is_moving = true
            level.pacman.is_moving = true


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
