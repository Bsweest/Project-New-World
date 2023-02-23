extends Reference

class_name DamageMachine

enum DamageType { PHYSIC, MAGIC, TRUE, PIERCE, HEAL }

var raw_damage: int = 0
var percent_damage : float = 0
var type: int = 0
var set_crit: bool = true
var attacker

func setter(_attacker, dmg: int, _type: int, setCrit: bool) -> void:
	attacker = _attacker
	raw_damage = dmg
	type = _type
	set_crit = setCrit

func modify(newDmg: int) -> void:
	raw_damage = newDmg

func attack_received(receiver) -> void:
	var cal_damage = raw_damage
	var is_crit := false
	if set_crit:
		is_crit = attacker.stats.isCrit()
	if is_crit:
		cal_damage = int(cal_damage * attacker.stats.get_crit_damage())
	var mul = receiver.stats.defense_multiplier(type)
	cal_damage *= mul
	var received_damage = create_damage_dictionary(receiver, cal_damage, is_crit)
	receiver.take_damage(received_damage)

func percent_heath_damage(receiver) -> void:
	var cal_damage = receiver.stats.max_hp * percent_damage
	var is_crit := false
	if set_crit:
		is_crit = attacker.stats.isCrit()
	if is_crit:
		raw_damage = int(raw_damage * attacker.stats.get_crit_damage())
	var mul = receiver.stats.defense_multiplier(type)
	cal_damage *= mul
	var received_damage = create_damage_dictionary(receiver, cal_damage, is_crit)
	receiver.take_damage(received_damage)

func heal_received(receiver) -> void:
	var received_heal = create_damage_dictionary(receiver, raw_damage, false)
	receiver.get_heal(received_heal)

func create_damage_dictionary(receiver, cal_damage: int, isCrit: bool) -> Dictionary:
	var dmg_dict = {}
	dmg_dict.receiver = receiver
	dmg_dict.cal_damage = cal_damage
	dmg_dict.type = type
	dmg_dict.is_crit = isCrit
	return dmg_dict