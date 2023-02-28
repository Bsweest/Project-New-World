extends Control

class_name StatusEffectIcon

enum EffectType { STATUS, STAT, DOT }

onready var _stat : Sprite = $Stat
onready var _status : Sprite = $Status
onready var _dot : Sprite = $DOT

var eff_type : int = 0
var stat_name : int = 0
var is_debuff := false

func setter(type: int, name: int, isDebuff: bool) -> void:
	eff_type = type
	stat_name =  name
	is_debuff = isDebuff

func _ready():
	match eff_type:
		EffectType.STATUS:
			_status.visible = true
			_status.frame = stat_name
		EffectType.STAT:
			_stat.visible = true
			if is_debuff:
				stat_name += 9
			_stat.frame = stat_name
		EffectType.DOT:
			pass
