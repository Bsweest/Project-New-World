extends Node2D

class_name AnimationUB

signal finish_ub(is_party, pos)

onready var _aniSprite : AnimatedSprite = $AnimatedSprite
onready var _area : Sprite = $D_Area

var pos : int

func _ready():
	_aniSprite.playing = false
	visible = false

func start_ub_ani(_position: Vector2, ub_hitbox_position: int) -> void:
	position = _position
	visible = true
	_aniSprite.frame = 0
	_aniSprite.playing = true

func _on_AnimatedSprite_animation_finished() -> void:
	visible = false
	emit_signal("finish_ub", pos)
