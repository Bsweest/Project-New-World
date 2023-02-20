extends NodeUB

class_name NodeUBShoot

#// Texture of Projectile
var _texture : String
var ub_txt : Texture
#// Mechanic
var is_kb : bool = true

func _ready():
	ub_txt = load(_texture)

func shoot_ub() -> void:
	character.fire_special_projectile(ub_txt, damageMachine, is_kb)

func activeUB(_ub_postion: int) -> void:
	var dmg = calc_skill_damage()
	damageMachine.modify(dmg)
	shoot_ub()

	
