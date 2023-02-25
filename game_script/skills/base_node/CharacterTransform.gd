extends Node2D

class_name CharacterTransform

signal end_transfrom()

onready var _aniPlayer : AnimationPlayer = $AnimationPlayer as AnimationPlayer
onready var _sprite : Sprite = $Sprite as Sprite
onready var _hitbox : HitBox = $HitBox as HitBox

var stats : CharacterStats
var skill : CharacterSkill
var is_party : bool
var is_active := false

func setter(isParty: bool, _stats: CharacterStats, _skill) -> void:
	self.is_party = isParty
	self.stats = _stats
	self.skill = _skill

func _ready():
	visible = false
	_hitbox.disable_collision()
	_hitbox.initHitbox(is_party)
		
func activeTransform() -> void:
	visible = true
	is_active = true
	_aniPlayer.play("transform")

func endTransform() -> void:
	visible = false
	is_active = false
	_hitbox.disable_collision()
	emit_signal("end_transfrom")

