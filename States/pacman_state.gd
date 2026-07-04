extends Node
class_name PacmanState

var pacman: Pacman
var wall_layer: TileMapLayer

func _process(delta: float) -> void:
    _snap_pacman_to_grid()

    if pacman.is_moving:
        _handle_movement(delta)

    pacman.sprite.rotation = pacman.direction.angle()

    if (pacman.position - pacman.last_position).length() > 0.1:
        pacman.sprite.play("move")
        pacman.last_position = pacman.position
    else:
        pacman.sprite.stop()

func _handle_movement(delta: float) -> void:
    var direction: Vector2 = pacman.direction

    if pacman.ignore_input_timer > 0:
        pacman.ignore_input_timer -= delta
    else:
        direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

    if direction != Vector2.ZERO:
        var collision:= pacman.move_and_collide(direction * pacman.speed * delta)
        if not collision:
            pacman.direction = direction
        else:
            pacman.future_direction = direction
            pacman.future_direction_timer = 0.5
            pacman.move_and_collide(pacman.direction * pacman.speed * delta)
    elif pacman.future_direction != Vector2.ZERO and pacman.future_direction_timer > 0:
        var collision:= pacman.move_and_collide(pacman.future_direction * pacman.speed * delta)
        pacman.future_direction_timer -= delta
        if not collision:
            pacman.direction = pacman.future_direction
            pacman.future_direction = Vector2.ZERO
            pacman.future_direction_timer = 0
        else:
            pacman.move_and_collide(pacman.direction * pacman.speed * delta)
    else:
        pacman.move_and_collide(pacman.direction * pacman.speed * delta)

    # If character stopped we should not hold this direction
    if absf((pacman.position - pacman.last_position).length()) < 0.1:
        pacman.future_direction_timer = 0

func _snap_pacman_to_grid() -> void:
    var cell:= wall_layer.local_to_map(pacman.position)
    var pos:= wall_layer.map_to_local(cell)

    if absf(pacman.position.x - pos.x) < 0.5:
        pacman.position.x = pos.x
    if absf(pacman.position.y - pos.y) < 0.5:
        pacman.position.y = pos.y
