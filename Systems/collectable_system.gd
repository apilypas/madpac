extends Node
class_name CollectableSystem

var level: Level

func _process(_delta: float) -> void:
    _handle_pellets()
    _handle_bonuses()

func _handle_pellets() -> void:
    var cell: = level.pellet_layer.local_to_map(level.pacman.position)
    var tile_data: = level.pellet_layer.get_cell_tile_data(cell)

    if tile_data:
        level.pellet_layer.erase_cell(cell)

func _handle_bonuses() -> void:
    var cell: = level.bonus_layer.local_to_map(level.pacman.position)
    var tile_data: = level.bonus_layer.get_cell_tile_data(cell)

    if tile_data:
        level.bonus_layer.erase_cell(cell)
        for ghost in level.ghosts:
            ghost.scared_timer = 5.0
