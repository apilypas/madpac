extends Node
class_name CollectableSystem

@export var game_state: GameState
@export var sfx_player: SfxPlayer
var level: Level

@export var points_label_scene: PackedScene

func _process(delta: float) -> void:
    if game_state.is_paused:
        return

    _handle_fruit_spawn()
    _handle_fruit_despawn(delta)
    _handle_pick_up()

func _handle_fruit_spawn() -> void:
    if !game_state.is_fruit_spawned_1 && game_state.level_pellets_collected == game_state.spawn_fruit_1_at:
        game_state.is_fruit_spawned_1 = true
        game_state.fruit_timer = Constants.DURATION_FRUIT
        var fruit_cell := level.pellet_layer.local_to_map(game_state.pacman_initial_pos)
        level.pellet_layer.set_cell(fruit_cell, 0, game_state.fruit_cell)
        sfx_player.play(Audio.Sfx.BONUS_SPAWNED)
        print("Fruit bonus (1) spawned!")

    if !game_state.is_fruit_spawned_2 && game_state.level_pellets_collected == game_state.spawn_fruit_2_at:
        game_state.is_fruit_spawned_2 = true
        game_state.fruit_timer = Constants.DURATION_FRUIT
        var fruit_cell := level.pellet_layer.local_to_map(game_state.pacman_initial_pos)
        level.pellet_layer.set_cell(fruit_cell, 0, game_state.fruit_cell)
        sfx_player.play(Audio.Sfx.BONUS_SPAWNED)
        print("Fruit bonus (2) spawned!")

func _handle_fruit_despawn(delta: float) -> void:
    if game_state.fruit_timer > 0:
        game_state.fruit_timer -= delta

        if game_state.fruit_timer <= 0:
            var fruit_cell := level.pellet_layer.local_to_map(game_state.pacman_initial_pos)
            var tile_data := level.pellet_layer.get_cell_tile_data(fruit_cell)
            if tile_data:
                level.pellet_layer.erase_cell(fruit_cell)
                print("Fruit bonus despawned!")

func _handle_pick_up() -> void:
    var cell := level.pellet_layer.local_to_map(level.pacman.position)
    var tile_data := level.pellet_layer.get_cell_tile_data(cell)

    if tile_data:
        var atlas_coords := level.pellet_layer.get_cell_atlas_coords(cell)

        if atlas_coords == Constants.PELLET_COORDS:
            level.pellet_layer.erase_cell(cell)
            game_state.score += Constants.SCORE_PELLET
            game_state.pellets += 1
            game_state.level_pellets_collected += 1
            sfx_player.play(Audio.Sfx.PICK)
            level.pacman.do_pulse()

        elif atlas_coords == Constants.BOOST_COORDS:
            level.pellet_layer.erase_cell(cell)
            game_state.score += Constants.SCORE_BONUS
            game_state.pellets += 1
            game_state.level_pellets_collected += 1
            sfx_player.play(Audio.Sfx.BONUS)
            level.pacman.do_pulse()
            for ghost in level.ghosts:
                ghost.scared_timer = Constants.DURATION_GHOST_SCARE

        elif atlas_coords == Constants.CHERRY_COORDS:
            level.pellet_layer.erase_cell(cell)
            game_state.score += Constants.SCORE_CHERRY
            sfx_player.play(Audio.Sfx.BONUS)
            level.pacman.do_pulse()
            _show_score(Constants.SCORE_CHERRY, cell)

        elif atlas_coords == Constants.STRAWBERRY_COORDS:
            level.pellet_layer.erase_cell(cell)
            game_state.score += Constants.SCORE_STRAWBERRY
            sfx_player.play(Audio.Sfx.BONUS)
            level.pacman.do_pulse()
            _show_score(Constants.SCORE_STRAWBERRY, cell)

        elif atlas_coords == Constants.ORANGE_COORDS:
            level.pellet_layer.erase_cell(cell)
            game_state.score += Constants.SCORE_ORANGE
            sfx_player.play(Audio.Sfx.BONUS)
            level.pacman.do_pulse()
            _show_score(Constants.SCORE_ORANGE, cell)

        elif atlas_coords == Constants.APPLE_COORDS:
            level.pellet_layer.erase_cell(cell)
            game_state.score += Constants.SCORE_APPLE
            sfx_player.play(Audio.Sfx.BONUS)
            level.pacman.do_pulse()
            _show_score(Constants.SCORE_APPLE, cell)

        elif atlas_coords == Constants.PEAR_COORDS:
            level.pellet_layer.erase_cell(cell)
            game_state.score += Constants.SCORE_PEAR
            sfx_player.play(Audio.Sfx.BONUS)
            level.pacman.do_pulse()
            _show_score(Constants.SCORE_PEAR, cell)

        elif atlas_coords == Constants.MEDAL_COORDS:
            level.pellet_layer.erase_cell(cell)
            game_state.score += Constants.SCORE_MEDAL
            sfx_player.play(Audio.Sfx.BONUS)
            level.pacman.do_pulse()
            _show_score(Constants.SCORE_MEDAL, cell)

        elif atlas_coords == Constants.CUP_COORDS:
            level.pellet_layer.erase_cell(cell)
            game_state.score += Constants.SCORE_CUP
            sfx_player.play(Audio.Sfx.BONUS)
            level.pacman.do_pulse()
            _show_score(Constants.SCORE_CUP, cell)

        elif atlas_coords == Constants.KEY_COORDS:
            level.pellet_layer.erase_cell(cell)
            game_state.score += Constants.SCORE_KEY
            sfx_player.play(Audio.Sfx.BONUS)
            level.pacman.do_pulse()
            _show_score(Constants.SCORE_KEY, cell)

func _show_score(score: int, cell: Vector2i) -> void:
    var pos := level.pellet_layer.map_to_local(cell)
    var label: PointsLabel = points_label_scene.instantiate()
    label.position = pos
    level.add_child(label)
    label.set_text(str(score))
