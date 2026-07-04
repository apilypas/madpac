extends Node
class_name GhostState

var pacman: Pacman
var ghosts: Array[Ghost] = []
var wall_layer: TileMapLayer

func _ready() -> void:
    pass

func _process(delta: float) -> void:
    for ghost in ghosts:
        if ghost.is_alive and ghost.is_moving:
            if _snap_to_grid(ghost):
                ghost.direction = _get_next_direction(ghost)

            if ghost.direction == Vector2.ZERO:
                ghost.direction = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN].pick_random()

            var collision: = ghost.move_and_collide(ghost.direction * ghost.speed * delta)
            if collision:
                ghost.direction = Vector2.ZERO

        _handle_animations(ghost)

        if ghost.scared_timer > 0:
            ghost.scared_timer -= delta

func _handle_animations(ghost: Ghost) -> void:
    if !ghost.is_alive:
        ghost.sprite.play("dead")
    elif ghost.scared_timer > 0:
        ghost.sprite.play("scared")
    elif ghost.direction == Vector2.RIGHT:
        ghost.sprite.play("move_right")
    elif ghost.direction == Vector2.LEFT:
        ghost.sprite.play("move_left")
    elif ghost.direction == Vector2.UP:
        ghost.sprite.play("move_up")
    elif ghost.direction == Vector2.DOWN:
        ghost.sprite.play("move_down")

func _get_next_direction(ghost: Ghost) -> Vector2:
    var pacman_cell: = wall_layer.local_to_map(pacman.position)
    var ghost_cell: = wall_layer.local_to_map(ghost.position)

    # Check if should turn to player
    if ghost.scared_timer <= 0 and (pacman_cell.x == ghost_cell.x or pacman_cell.y == ghost_cell.y):
        if pacman_cell.x == ghost_cell.x:
            var has_path: bool = true
            var step: int = 1 if ghost_cell.y < pacman_cell.y else -1
            for i in range(ghost_cell.y + 1, pacman_cell.y, step):
                var cell: = Vector2i(pacman_cell.x, i)
                if wall_layer.get_cell_tile_data(cell):
                    has_path = false
                    break
            if has_path:
                return Vector2.DOWN if step == 1 else Vector2.UP
        if pacman_cell.y == ghost_cell.y:
            var has_path: bool = true
            var step: int = 1 if ghost_cell.x < pacman_cell.x else -1
            for i in range(ghost_cell.x + 1, pacman_cell.x, step):
                var cell: = Vector2i(i, pacman_cell.y)
                if wall_layer.get_cell_tile_data(cell):
                    has_path = false
                    break
            if has_path:
                return Vector2.RIGHT if step == 1 else Vector2.LEFT

    # Check if should continue path
    if _check_direction(ghost, ghost.direction):
        # Give small chance to turn from straight path
        if randi() % 2 == 0:
            if ghost.direction == Vector2.LEFT or ghost.direction == Vector2.RIGHT:
                var direction: Vector2 = [Vector2.UP, Vector2.DOWN].pick_random()
                if _check_direction(ghost, direction):
                    return direction
            if ghost.direction == Vector2.UP or ghost.direction == Vector2.DOWN:
                var direction: Vector2 = [Vector2.LEFT, Vector2.RIGHT].pick_random()
                if _check_direction(ghost, direction):
                    return direction
        return ghost.direction

    # If can't go straight change direction, but don't go back
    if ghost.direction == Vector2.LEFT or ghost.direction == Vector2.RIGHT:
        var directions:Array[Vector2] = []
        if _check_direction(ghost, Vector2.UP):
            directions.append(Vector2.UP)
        if _check_direction(ghost, Vector2.DOWN):
            directions.append(Vector2.DOWN)
        if directions.size() == 0:
            directions.append(Vector2.ZERO)
        return directions.pick_random()
    elif ghost.direction == Vector2.UP or ghost.direction == Vector2.DOWN:
        var directions:Array[Vector2] = []
        if _check_direction(ghost, Vector2.LEFT):
            directions.append(Vector2.LEFT)
        if _check_direction(ghost, Vector2.RIGHT):
            directions.append(Vector2.RIGHT)
        if directions.size() == 0:
            directions.append(Vector2.ZERO)
        return directions.pick_random()

    return Vector2.ZERO

func _check_direction(ghost: Ghost, direction: Vector2) -> bool:
    var pos: = ghost.position + direction * 16
    var cell: = wall_layer.local_to_map(pos)
    var tile_data: = wall_layer.get_cell_tile_data(cell)
    return tile_data == null

func _snap_to_grid(ghost: Ghost) -> bool:
    var is_snapped_x: bool = false
    var is_snapped_y: bool = false
    var cell: = wall_layer.local_to_map(ghost.position)
    var pos: = wall_layer.map_to_local(cell)

    if absf(ghost.position.x - pos.x) < 0.5:
        ghost.position.x = pos.x
        is_snapped_x = true
    if absf(ghost.position.y - pos.y) < 0.5:
        ghost.position.y = pos.y
        is_snapped_y = true

    return is_snapped_x and is_snapped_y
