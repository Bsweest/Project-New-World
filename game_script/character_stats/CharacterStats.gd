extends Node

class_name CharacterStats

enum BaseClass { FIGHTER, DEFENDER, PALADIN, ARCHER, MAGE, HEALER }
enum DamameType { PHYSIC, MAGIC, TRUE, PIERCE }
enum { PHYSIC, MAGIC, P_DEFENSE, M_ARMOR, CRIT_C, CRIT_DMG, SPEED, DMG_MOD, TP_MOD }

signal hp_changed(new_hp, damage)
signal hp_depleted()
signal stat_changed(name)

var un_modified = {
	PHYSIC: 0,
	MAGIC: 0,
	P_DEFENSE: 0,
	M_ARMOR: 0,
	CRIT_C: 0,
	CRIT_DMG: 0,
	SPEED: 0,
	DMG_MOD : -1.0,
	TP_MOD: 1.0,
}

var current_stat = {
	PHYSIC: 0,
	MAGIC: 0,
	P_DEFENSE: 0,
	M_ARMOR: 0,
	CRIT_C: 0,
	CRIT_DMG: 0,
	SPEED: 0,
	DMG_MOD: -1.0,
	TP_MOD: 1.0,
}

var max_hp : int = 0
var current_hp : int = 0

var c_range : int
var c_class : int
var projectile : String
var is_ranged : bool = false

func create_stat_dictionary(dic: Dictionary, stats: BaseStats, lvl: int) -> void:
	dic[PHYSIC] = int(stats.physic * (1 + (lvl) * 0.15) + lvl * 5)
	dic[MAGIC] = int(stats.magic * (1 + (lvl) * 0.15) + lvl * 5)
	dic[P_DEFENSE] = int(stats.p_defense * (1 + (lvl) * 0.15) + lvl * 2.5)
	dic[M_ARMOR] = int(stats.m_armor * (1 + (lvl) * 0.15) + lvl * 2.5)
	dic[CRIT_C] = stats.crit_c / 100.0
	dic[CRIT_DMG] = stats.crit_dmg / 100.0
	dic[SPEED] = stats.speed

func init(stats: BaseStats, lvl: int) -> void:
	lvl -= 1
	max_hp = int(stats.max_hp * (1 + (lvl) * 0.15) + lvl * 50)
	current_hp = max_hp
	c_class = stats.base_class
	c_range = stats.attack_range
	projectile = stats.projectile_texture
	if c_class == BaseClass.ARCHER || c_class == BaseClass.MAGE || c_class == BaseClass.HEALER:
		is_ranged = true
	create_stat_dictionary(un_modified, stats, lvl)
	create_stat_dictionary(current_stat, stats, lvl)	

func _modify_stat(stat_name: int, flat: int, percent: float) -> void:
	if stat_name  > 8 || stat_name < 0:
		return
	var mod_value = un_modified[stat_name] * percent + flat
	current_stat[stat_name] += mod_value
	emit_signal("stat_changed", stat_name)


#? get function
func isCrit() -> bool:
	var thresh = randf()
	if thresh > 1 - current_stat[CRIT_C]:
		return true
	return false

func get_crit_damage() -> float:
	return current_stat[CRIT_DMG]

func get_physic() -> int:
	return current_stat[PHYSIC]

func get_magic() -> int:
	return current_stat[MAGIC]

func get_speed() -> int:
	return current_stat[SPEED]

func get_tp_boost() -> float:
	return current_stat[TP_MOD]

func defense_multiplier(type: int) -> float:
	var mul = 0
	if type == DamameType.PHYSIC:
		mul = current_stat[PHYSIC]
	elif type == DamameType.MAGIC:
		mul = current_stat[MAGIC]
	return 100.0 / (100 + mul) * - current_stat[DMG_MOD]


func take_calculated_dmg(damage: Dictionary) -> void:
	current_hp -= damage.cal_damage
	current_hp = int(max(0, current_hp))
	current_hp = int(min(max_hp, current_hp))
	emit_signal("hp_changed", current_hp, damage)
	if current_hp == 0:
		emit_signal("hp_depleted")
