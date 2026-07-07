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
        var camera: = Camera2D.new()
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

        game_state.ready_timer = Constants.DURATION_READY
        game_state.is_paused = true
        game_state.level = index + 1
    else:
        game_state.is_game_end = true
