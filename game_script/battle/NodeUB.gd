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

export (PackedScene) var transform_scene
var transfrom_node : CharacterTransform
var has_tranform := false

var character

func ub_set(isParty: bool, c_stats: CharacterStats, c_skill: CharacterSkill, _character) -> void:
	is_party = isParty
	stats = c_stats
	skill = c_skill
	character = _character
	damageMachine.setter(owner, 0, skill.type, false)
	if transform_scene != null:
		has_tranform = true
		transfrom_node = transform_scene.instance()
		transfrom_node.setter(is_party, stats, skill)
		# warning-ignore:return_value_discarded
		transfrom_node.connect('end_transfrom', character, '_on_end_Transform')
		character.add_child(transfrom_node)
	_set_hitbox()
	_set_side_effect()

func _set_hitbox() -> void:
	pass

func _set_side_effect() -> void:
	pass

func setup_formation(ally: Array, enemy: Array) -> void:
	if is_party:
		members = ally
		opponents = enemy
	else:
		members = enemy
		opponents = ally

func calc_skill_damage() -> int:
	var dmg : int = 0
	if skill.type == DamameType.PHYSIC:
		dmg += stats.get_physic() * ( 100 + skill.base_dmg ) / 100
	elif skill.type == DamameType.MAGIC:
		dmg += stats.get_magic() * ( 100 + skill.base_dmg ) / 100
	return dmg

func activeUB(_ub_postion: int) -> void:
	if has_tranform:
		transfrom_node.activeTransform()

func _on_character_death() -> void:
	if has_tranform:
		transfrom_node.endTransform()
