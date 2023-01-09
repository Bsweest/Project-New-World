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

func setter(dmg: int, is_crit: bool, type: int, is_kb: bool) -> void:
	self.dmg = dmg
	self.is_crit = is_crit
	self.type = type
	self.is_kb = is_kb

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
