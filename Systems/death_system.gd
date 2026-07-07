extends Node
class_name DeathSystem

@export var game_state: GameState
@export var sfx_player: SfxPlayer

var level: Level

var _spawn_position: Vector2
var _ghost_positions: Dictionary[Ghost, Vector2] = {}
var _ghost_spawn_timer: float = Constants.DURATION_GHOST_DOOR_OPEN
var _hit_stop_timer: float = 0
var _pacman_death_timer: float = 0

func init() -> void:
    _spawn_position = level.pacman.position
    _ghost_positions.clear()
    for ghost in level.ghosts:
        _ghost_positions[ghost] = ghost.position

func _process(delta: float) -> void:
    if !game_state.is_paused:
        for ghost in level.ghosts:
            if ghost.is_alive and ghost.position.distance_to(level.pacman.position) < Constants.TILE_SIZE:
                if ghost.scared_timer > 0:
                    ghost.scared_timer = 0
                    ghost.is_spawned = false
                    ghost.is_alive = false
                    ghost.speed += 20.0
                    _hit_stop_timer = 0.2
                    game_state.score += Constants.SCORE_GHOST_KILL
                    game_state.enemies += 1
                    sfx_player.play(Audio.Sfx.KILL)
                    var tween: = create_tween()
                    tween.tween_property(ghost, "position", _ghost_positions[ghost], 0.3)
                    tween.tween_property(ghost, "is_alive", true, 0)
                else:
                    game_state.lives -= 1
                    game_state.is_paused = true
                    game_state.can_pause = false
                    level.pacman.is_alive = false
                    level.pacman.is_moving = false
                    _pacman_death_timer = Constants.DURATION_PLAYER_DEATH
                    sfx_player.play(Audio.Sfx.DIED)

        _handle_ghost_spawning(delta)
        _handle_hit_stop(delta)

    _handle_pacman_death(delta)

func _handle_pacman_death(delta: float) -> void:
    if _pacman_death_timer > 0:
        _pacman_death_timer -= delta
        if _pacman_death_timer <= 0:
            if game_state.lives <= 0:
                game_state.is_game_over = true
            else:
                level.pacman.position = _spawn_position
                level.pacman.direction = Vector2.ZERO
                level.pacman.is_alive = true
                level.pacman.is_moving = true
                level.pacman.sprite.play("move")
                level.pacman.sprite.stop()
                game_state.ready_timer = Constants.DURATION_READY
                _ghost_spawn_timer = Constants.DURATION_GHOST_DOOR_OPEN
                for g in level.ghosts:
                    g.position = _ghost_positions[g]
                    g.is_spawned = false
                    g.scared_timer = 0

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
        _ghost_spawn_timer += Constants.DURATION_GHOST_DOOR_OPEN
        var ghosts: Array[Ghost] = []
        for ghost in level.ghosts:
            if !ghost.is_spawned:
                ghosts.append(ghost)
        if ghosts.size() > 0:
            var ghost: Ghost = ghosts.pick_random()
            ghost.is_spawned = true
            ghost.is_moving = false
            var closest: = _find_closest_ghost_spawn_position(ghost)
            var tween: = create_tween()
            tween.tween_property(ghost, "scale", Vector2(0, 0), 0.2)
            tween.tween_property(ghost, "position", closest, 0)
            tween.tween_property(ghost, "scale", Vector2(1, 1), 0.2)
            tween.tween_property(ghost, "is_moving", true, 0)

func _find_closest_ghost_spawn_position(ghost: Ghost) -> Vector2:
    var closest: Vector2 = level.ghost_spawn_markers[0].position
    for m in level.ghost_spawn_markers:
        if ghost.position.distance_to(m.position) < ghost.position.distance_to(closest):
            closest = m.position
    return closest
