extends Node2D

class_name NodeUB

enum DamameType { PHYSIC, MAGIC, TRUE, PIERCE }

# var _particle
var is_party : bool
var stats : CharacterStats
var skill : CharacterSkill

var damageMachine := DamageMachine.new()

var members : Array 
var opponents : Array

var character

func ub_set(isParty: bool, c_stats: CharacterStats, c_skill: CharacterSkill, _character) -> void:
	is_party = isParty
	stats = c_stats
	skill = c_skill
	character = _character
	damageMachine.setter(owner, 0, skill.type, false)

func _ready() -> void:
	pass

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
	pass
