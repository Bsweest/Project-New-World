extends Node2D

class_name AnimationUB

signal finish_ub(is_party, pos)

onready var _aniSprite : AnimatedSprite = $AnimatedSprite

var pos : int

func _ready():
	_aniSprite.playing = false
	_aniSprite.connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")
	visible = false

func start_ub_ani(_position: Vector2) -> void:
	position = _position
	visible = true
	_aniSprite.frame = 0
	_aniSprite.playing = true

func _on_AnimatedSprite_animation_finished() -> void:
	visible = false
	emit_signal("finish_ub", pos)
