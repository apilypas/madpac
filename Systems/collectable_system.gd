extends Node

@export var pacman: Pacman
@export var pellet_layer: TileMapLayer
@export var bonus_layer: TileMapLayer
@export var ghosts: Array[Ghost] = []

func _process(_delta: float) -> void:
    _handle_pellets()
    _handle_bonuses()

func _handle_pellets() -> void:
    var cell: = pellet_layer.local_to_map(pacman.position)
    var tile_data: = pellet_layer.get_cell_tile_data(cell)

    if tile_data:
        pellet_layer.erase_cell(cell)

func _handle_bonuses() -> void:
    var cell: = bonus_layer.local_to_map(pacman.position)
    var tile_data: = bonus_layer.get_cell_tile_data(cell)

    if tile_data:
        bonus_layer.erase_cell(cell)
        for ghost in ghosts:
            ghost.scared_timer = 5.0
