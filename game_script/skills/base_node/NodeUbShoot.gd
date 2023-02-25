extends NodeUB

class_name NodeUBShoot

#// Texture of Projectile
var _texture : String
var ub_txt : Texture
#// Mechanic
var is_kb : bool = true
var mod_speed : float = 1
var num_target: = 1

func _ready():
	ub_txt = load(_texture)

func shoot_ub() -> void:
	character.fire_special_projectile(ub_txt, damageMachine, is_kb, mod_speed, num_target)

func activeUB(_ub_postion: int) -> void:
	var dmg = calc_skill_damage()
	damageMachine.modify(dmg)
	shoot_ub()

	
