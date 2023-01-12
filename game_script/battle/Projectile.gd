extends Node2D

class_name Projectile

enum DamameType { PHYSIC, MAGIC, TRUE, PIERCE, HEAL }

onready var _hitbox : HitBox = $HitBox
onready var _sprite : Sprite = $Sprite
onready var _aniPlayer : AnimationPlayer = $AnimationPlayer

var SPEED := 250
var dir := -1
var _texture : Texture
var dmg : int
var is_crit: bool
var type : int
var is_party : bool
var is_kb : bool
var num_target : int = 1

func projectile_setter(isParty: bool, _txt: Texture, dmg: int, is_crit: bool, type: int, is_kb: bool) -> void:
	self.is_party = isParty
	self._texture = _txt
	self.dmg = dmg
	self.is_crit = is_crit
	self.type = type
	self.is_kb = is_kb

func modify_projectile(mod_speed: float, numTarget: int) -> void:
	SPEED *= mod_speed
	num_target = numTarget

func _ready():
	_hitbox.setter(dmg, is_crit, type, is_kb)
	_hitbox.init(is_party)
	_sprite.set_texture(_texture)
	_aniPlayer.play("Shoot")
	position.x = -20

func _physics_process(_delta: float):
	position.x += SPEED * dir * _delta

func _on_HitBox_body_entered(body):
	if body.get_class() == "Entity":
		num_target -= 1
		if num_target == 0:
			queue_free()	
	if body.get_class() == "StaticBody2D":
		queue_free()

func get_class() -> String: return "Projectile"
