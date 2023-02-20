extends Reference

class_name DamageMachine

enum DamageType { PHYSIC, MAGIC, TRUE, PIERCE, HEAL }

var raw_damage: int
var type: int
var set_crit: bool
var attacker

func setter(_attacker, dmg: int, _type: int, setCrit: bool) -> void:
	attacker = _attacker
	raw_damage = dmg
	type = _type
	set_crit = setCrit

func modify(newDmg: int) -> void:
	raw_damage = newDmg

func attack_received(receiver) -> void:
	var received_damage = {}
	var cal_damage = raw_damage
	var is_crit := false
	if set_crit:
		is_crit = attacker.stats.isCrit()
	if is_crit:
		raw_damage = int(raw_damage * attacker.stats.crit_dmg)
	var mul = receiver.stats.defense_multiplier(type)
	cal_damage *= mul
	received_damage.receiver = receiver
	received_damage.is_crit = is_crit
	received_damage.cal_damage = cal_damage
	received_damage.type = type
	receiver.take_damage(received_damage)

func heal_received(receiver) -> void:
	var received_heal = {}
	received_heal.receiver = receiver
	received_heal.cal_damage = raw_damage
	received_heal.type = 4
	received_heal.is_crit = false
	receiver.get_heal(received_heal)

	
