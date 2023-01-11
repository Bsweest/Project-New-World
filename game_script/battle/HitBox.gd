extends Area2D

class_name HitBox

onready var _collision : CollisionShape2D = $CollisionShape2D

var dmg : int = 0
var is_crit : bool = false
var type : int = 0
var is_kb : bool = true

func _init():
	set_collision_layer_bit(1, false)
	set_collision_mask_bit(1, false)

func setter(damage: int, isCrit: bool, _type: int, isKB: bool) -> void:
	self.dmg = damage
	self.is_crit = isCrit
	self.type = _type
	self.is_kb = isKB

#! layer của hitbox == layer character
func init(is_party: bool) -> void:
	var layer = 2
	if is_party:
		layer = 1
	set_collision_layer_bit(layer, true)

func enable_collision() -> void:
	_collision.set_deferred("disabled", false)

func disable_collision() -> void:
	_collision.set_deferred("disabled", true)
