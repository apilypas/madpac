extends Node
class_name TunnelSystem

var level: Level

func _process(delta: float) -> void:
    var entry: Tunnel = null
    var exit: Tunnel = null

    for tunnel in level.tunnels:
        if tunnel.in_use_timer > 0:
            tunnel.in_use_timer -= delta
        if tunnel.position.distance_to(level.pacman.position) < 3:
            entry = tunnel

    if entry != null:
        for tunnel in level.tunnels:
            if tunnel != entry and tunnel.in_use_timer <= 0 and tunnel.network_id == entry.network_id:
                exit = tunnel
                break

    if entry != null and exit != null:
        level.pacman.position = exit.position
        level.pacman.ignore_input_timer = 0.2
        entry.in_use_timer = 0.2
        exit.in_use_timer = 0.2
