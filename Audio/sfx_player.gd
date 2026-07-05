extends Node
class_name SfxPlayer

@onready var _pick_player: AudioStreamPlayer = $PickPlayer
@onready var _bonus_player: AudioStreamPlayer = $BonusPlayer
@onready var _tunnel_player: AudioStreamPlayer = $TunnelPlayer
@onready var _died_player: AudioStreamPlayer = $DiedPlayer
@onready var _kill_player: AudioStreamPlayer = $KillPlayer

func play(sfx: Audio.Sfx) -> void:
    if sfx == Audio.Sfx.PICK:
        _pick_player.pitch_scale = randf_range(0.6, 1.4)
        _pick_player.play()
    elif sfx == Audio.Sfx.BONUS:
        _bonus_player.play()
    elif sfx == Audio.Sfx.TUNNEL:
        _tunnel_player.play()
    elif sfx == Audio.Sfx.DIED:
        _died_player.play()
    elif sfx == Audio.Sfx.KILL:
        _kill_player.play()
