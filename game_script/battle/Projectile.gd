extends Node2D

class_name Projectile

enum DamameType { PHYSIC, MAGIC, TRUE, PIERCE, HEAL }

onready var _hitbox : HitBox = $HitBox
onready var _sprite : Sprite = $Sprite
onready var _aniPlayer : AnimationPlayer = $AnimationPlayer

var SPEED := 250
var dir := -1
var _texture : Texture
var dmgMachine : DamageMachine
var is_party : bool
var is_kb : bool
var num_target : int = 1
var is_special: bool = false

var is_done := false
var before_free := 2

func projectile_setter(isParty: bool, _txt: Texture, dmgMech: DamageMachine, isKB: bool) -> void:
	self.is_party = isParty
	self._texture = _txt
	self.dmgMachine = dmgMech
	self.is_kb = isKB

func modify_projectile(mod_speed: float, numTarget: int) -> void:
	SPEED = int(SPEED * mod_speed)
	num_target = numTarget

func _ready():
	_hitbox.initHitbox(is_party)
	_hitbox.setter(dmgMachine, is_kb)
	_sprite.set_texture(_texture)
	_aniPlayer.play("Shoot")
	position.x = -20

func _physics_process(_delta: float):
	if is_done:
		before_free -= 1
		if before_free == 0:
			queue_free()
	position.x += SPEED * dir * _delta

func _on_HitBox_area_entered(area):
	if not area.get_class() == "HurtBox":
		return
	num_target -= 1
	if num_target == 0:
		_hitbox.disable_collision()
		visible = false
		is_done = true

func _on_HitBox_body_entered(body) -> void:	
	if body.get_class() == "StaticBody2D":
		queue_free()
		

func get_class() -> String: return "Projectile"
