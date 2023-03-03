extends Area2D

class_name HitBox


onready var _collision : CollisionShape2D = $CollisionShape2D

var dmgMachine: DamageMachine
var is_kb : bool = true

func _init():
	set_collision_layer_bit(1, false)
	set_collision_mask_bit(1, false)

func setter(dmgMech: DamageMachine, isKB: bool) -> void:
	self.dmgMachine = dmgMech
	self.is_kb = isKB

#! layer của hitbox == layer character
func initHitbox(is_party: bool) -> void:
	var layer = 2
	if is_party:
		layer = 1
	set_collision_layer_bit(layer, true)

func enable_collision() -> void:
	_collision.set_deferred("disabled", false)

func disable_collision() -> void:
	_collision.set_deferred("disabled", true)
