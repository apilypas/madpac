extends Node
class_name LevelManager

@export var container_node: Node
@export var game_state: GameState
@export var level_scenes: Array[PackedScene] = []
@export var pacman_state: PacmanState
@export var ghost_state: GhostState
@export var collectable_system: CollectableSystem
@export var tunnel_system: TunnelSystem
@export var death_system: DeathSystem

@export var current_level_index: int = 0

var _level: Level

func _ready() -> void:
    _load(current_level_index)

func _process(_delta: float) -> void:
    # Handle level change
    if _level.is_all_collected():
        current_level_index += 1
        game_state.lives += 1
        _load(current_level_index)

func _load(index: int) -> void:
    if index < level_scenes.size():
        for child in container_node.get_children():
            child.queue_free()

        _level = level_scenes[index].instantiate()
        container_node.add_child(_level)

        # Set up camera for a player character
        var camera := Camera2D.new()
        camera.zoom = Vector2(1.0, 1.0)
        camera.limit_left = int(_level.area.position.x)
        camera.limit_right = int(_level.area.position.x + _level.area.size.x)
        camera.limit_top = int(_level.area.position.y)
        camera.limit_bottom = int(_level.area.position.y + _level.area.size.y)
        _level.pacman.add_child(camera)

        # Update data for player behavior
        pacman_state.pacman = _level.pacman
        pacman_state.wall_layer = _level.wall_layer

        # Update data for enemy behavior
        ghost_state.pacman = _level.pacman
        ghost_state.ghosts = _level.ghosts
        ghost_state.wall_layer = _level.wall_layer

        # Update data for systems
        collectable_system.level = _level
        tunnel_system.level = _level
        death_system.level = _level
        death_system.init()

        # Update game state values
        game_state.ready_timer = Constants.DURATION_READY
        game_state.is_paused = true
        game_state.level = index + 1
        game_state.level_pellets_collected = 0
        game_state.pacman_initial_pos = _level.pacman.position
        game_state.is_fruit_spawned_1 = false
        game_state.is_fruit_spawned_2 = false
        game_state.fruit_timer = 0
        game_state.spawn_fruit_1_at = roundi(_get_pellet_count() / 3.0);
        game_state.spawn_fruit_2_at = roundi(_get_pellet_count() / 3.0 * 2.0)
        game_state.fruit_cell = _get_level_fruit(game_state.level)
    else:
        game_state.is_game_end = true

func _get_pellet_count() -> int:
    var count: int = 0
    for cell in _level.pellet_layer.get_used_cells():
        var atlas_coords := _level.pellet_layer.get_cell_atlas_coords(cell)
        if atlas_coords == Constants.PELLET_COORDS or atlas_coords == Constants.BOOST_COORDS:
            count += 1
            
    return count

func _get_level_fruit(level: int) -> Vector2i:
    if level == 1:
        return Constants.CHERRY_COORDS
    if level == 2:
        return Constants.STRAWBERRY_COORDS
    if level == 3:
        return Constants.ORANGE_COORDS
    if level == 4:
        return Constants.APPLE_COORDS
    if level == 5:
        return Constants.PEAR_COORDS
    if level == 6:
        return Constants.MEDAL_COORDS
    if level == 7:
        return Constants.MEDAL_COORDS
    if level == 8:
        return Constants.CUP_COORDS

    return Constants.KEY_COORDS