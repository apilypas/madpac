extends Node
class_name Level

@export var area: Control
@export var pacman: Pacman
@export var ghosts: Array[Ghost] = []
@export var tunnels: Array[Tunnel] = []
@export var ghost_spawn_marker: Marker2D
@export var wall_layer: TileMapLayer
@export var pellet_layer: TileMapLayer
@export var bonus_layer: TileMapLayer
