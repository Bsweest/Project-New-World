extends Node2D

class_name NodeUB

enum DamameType { PHYSIC, MAGIC, TRUE, PIERCE }

onready var _hitbox : HitBox = $HitBox
onready var _coll : CollisionShape2D = $HitBox/CollisionShape2D

var _particle
var is_party : bool
var stats : CharacterStats
var skill : CharacterSkill

var members : Array 
var opponents : Array

var first_use : bool = false
var wait_time : float = 0.1
var timer = Timer.new()

func ready_set(is_member: bool, c_stats: CharacterStats, c_skill) -> void:
	is_party = is_member
	stats = c_stats
	skill = c_skill
	_hitbox.init(is_party)

func _ready() -> void:
	_hitbox.disable_collision()
	timer.wait_time = wait_time
	timer.one_shot = true
	timer.connect("timeout", self, "_timer_out")
	add_child(timer)

func setup_formation(_members: Array, _opponents: Array) -> void:
	members = _members
	opponents = _opponents

func calc_skill_damage() -> int:
	var dmg : int = 0
	if skill.type == DamameType.PHYSIC:
		dmg += stats.physic * ( 100 + skill.base_dmg ) / 100
	elif skill.type == DamameType.MAGIC:
		dmg += stats.magic * ( 100 + skill.base_dmg ) / 100
	
	return dmg

func activeUB(ub_postion: int) -> void:
	if ub_postion != 0:
		_hitbox.global_position = Vector2(ub_postion, 250)
	if !first_use:
		first_use = true
		_hitbox.scale = Vector2(1, 1)
	var dmg = calc_skill_damage()
	var is_crit = Utils.isCrit(stats.crit_c)
	if is_crit:
		dmg *= stats.crit_dmg
	_hitbox.setter(dmg, is_crit, skill.type, true)
	_hitbox.enable_collision()
	timer.start()

func _timer_out() -> void:
	_hitbox.disable_collision()
