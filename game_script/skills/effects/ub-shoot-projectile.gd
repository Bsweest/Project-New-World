extends NodeUB

class_name NodeUBShoot

var _texture : String = "res://assets/projectile/spark.png"
var ub_txt : Texture
var _char
var is_kb : bool = true
var num_shoot : = 3
var _repeat := 0

func _init():
	wait_time = 0.2

func _ready():
	ub_txt = load(_texture)
	_char = get_parent()

func shoot_ub() -> void:
	var dmg = calc_skill_damage()
	_char.fire_special_projectile(ub_txt, dmg, skill.type, is_kb)

func activeUB(_ub_postion: int) -> void:
	shoot_ub()
	_repeat += 1
	if _repeat == num_shoot:
		_repeat = 0
		return
	else:
		timer.start()

func _timer_out() -> void:
	activeUB(0)
	
