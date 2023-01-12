extends NodeUB

class_name NodeUBShoot

var _texture : String
var ub_txt : Texture
var _char
var is_kb : bool = true
var num_shoot : = 1
var have_repeat := 0

func _ready():
	ub_txt = load(_texture)
	_char = get_parent()

func shoot_ub() -> void:
	var dmg = calc_skill_damage()
	_char.fire_special_projectile(ub_txt, dmg, skill.type, is_kb)

func activeUB(_ub_postion: int) -> void:
	shoot_ub()
	have_repeat += 1
	if have_repeat == num_shoot:
		have_repeat = 0
		return
	else:
		timer.start()

func _timer_out() -> void:
	activeUB(0)
	
