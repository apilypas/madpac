extends Node2D

var _pacman: Pacman
var _pellet_layer: TileMapLayer
var _bonus_layer: TileMapLayer

func _ready() -> void:
    _pacman = get_node("Pacman")
    _pellet_layer = get_node("PelletLayer")
    _bonus_layer = get_node("BonusLayer")


func _process(_delta: float) -> void:
    _handle_pellets()
    _handle_bonuses()

func _handle_pellets() -> void:
    var cell: = _pellet_layer.local_to_map(_pacman.position)
    var tile_data: = _pellet_layer.get_cell_tile_data(cell)

    if tile_data:
        _pellet_layer.erase_cell(cell)

func _handle_bonuses() -> void:
    var cell := _bonus_layer.local_to_map(_pacman.position)
    var tile_data := _bonus_layer.get_cell_tile_data(cell)

    if tile_data:
        _bonus_layer.erase_cell(cell)
