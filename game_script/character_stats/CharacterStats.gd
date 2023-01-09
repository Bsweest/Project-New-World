extends Node

class_name CharacterStats

enum BaseClass { FIGHTER, DEFENDER, PALADIN, ARCHER, MAGE, HEALER }
enum DamameType { PHYSIC, MAGIC, TRUE, PIERCE }

signal hp_changed(new_hp, amount, is_crit, type)
signal hp_depleted()

var max_hp : int
var current_hp : int
var physic : int
var magic : int
var p_defense : int
var m_armor : int
var crit_c : float
var crit_dmg: float
var speed : int
var c_range : int
var c_class : int
var projectile : String

var is_ranged : bool = false

func init(stats: BaseStats, lvl: int) -> void:
	max_hp = stats.max_hp
	current_hp = stats.max_hp
	physic = stats.physic
	magic = stats.magic
	p_defense = stats.p_defense
	m_armor = stats.m_armor
	crit_c = stats.crit_c / 100.0
	crit_dmg = stats.crit_dmg / 100.0
	speed = stats.speed
	c_class = stats.base_class
	c_range = stats.attack_range
	projectile = stats.projectile_texture
	if c_class == BaseClass.ARCHER || c_class == BaseClass.MAGE || c_class == BaseClass.HEALER:
		is_ranged = true

func defense_multiplier(type: int) -> float:
	var mul = 0
	if type == DamameType.PHYSIC:
		mul = physic
	elif type == DamameType.MAGIC:
		mul = magic
	return 100.0 / (100 + mul)

func take_dmg(amount: int, is_crit: bool, type: int) -> void:
	current_hp -= amount
	current_hp = max(0, current_hp)
	if current_hp > max_hp:
		current_hp = max_hp
	emit_signal("hp_changed", current_hp, amount, is_crit, type)
	if current_hp == 0:
		emit_signal("hp_depleted")
