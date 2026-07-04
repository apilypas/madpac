extends Node
class_name CollectableSystem

@export var game_state: GameState
var level: Level

func _process(_delta: float) -> void:
    if game_state.is_paused:
        return

    _handle_pellets()
    _handle_bonuses()

func _handle_pellets() -> void:
    var cell: = level.pellet_layer.local_to_map(level.pacman.position)
    var tile_data: = level.pellet_layer.get_cell_tile_data(cell)

    if tile_data:
        level.pellet_layer.erase_cell(cell)
        game_state.score += 10

func _handle_bonuses() -> void:
    var cell: = level.bonus_layer.local_to_map(level.pacman.position)
    var tile_data: = level.bonus_layer.get_cell_tile_data(cell)

    if tile_data:
        level.bonus_layer.erase_cell(cell)
        game_state.score += 100
        for ghost in level.ghosts:
            ghost.scared_timer = 5.0
