extends Node

class_name Effect

enum EffectType { STATUS, STAT, DOT }
enum StatusName  { IMMUNE, CURSE, SILENT, STUN, FREEZE, SHOCK }
enum StatChange  { PHYSIC, MAGIC, P_DEFENSE, M_ARMOR, CRIT_C, CRIT_DMG, SPEED, DMG_MOD, TP_MOD }
enum DotName  { BURN, BLEEDING, POISION, DECOMPOSITION }
enum DamageType { PHYSIC, MAGIC, TRUE, PIERCE, HEAL }

var scene_icon = preload("res://components/UI/UIEffectIcon.tscn")

signal effect_apply(eff_name, flat, percent)
signal status_apply(status_name, is_increase)

var applier
var type : int = 0

var is_debuff := false
var cleanable := false

var status_name : int = -1
var stat_name : int = -1
var dot_name : int = -1

var flat_value : int = 0
var percent_value : float = 0

var duration_time : float = 0
var timer = Timer.new()
var tick_time : float = 0.5
var tick_timer = Timer.new()

var icon : StatusEffectIcon = scene_icon.instance()

var damageMachine : DamageMachine

func set_default(_applier, time: float) -> void:
	applier = _applier
	duration_time = time

func set_status(name: int) -> void:
	type = EffectType.STATUS
	status_name = name
	if name > 0:
		is_debuff = true
	icon.setter(type, name, is_debuff)

func set_stat(name: int, flat: int, percent: int) -> void:
	type = EffectType.STAT
	stat_name = name
	flat_value = flat
	percent_value = percent / 100.0
	if flat_value < 0 || percent_value < 0:
		is_debuff = true
	icon.setter(type, name, is_debuff)

func set_dot(name: int, flat: int, percent: int) -> void:
	type = EffectType.DOT
	stat_name = name
	flat_value = flat
	percent_value = percent / 100.0
	if flat_value > 0 || percent_value > 0:
		is_debuff = true
	icon.setter(type, name, is_debuff)

func _ready():
	timer.wait_time = duration_time
	timer.one_shot = true
	timer.connect("timeout", self, "_effect_run_out")
	add_child(timer)
	timer.start()
	signal_effect_start()

func signal_effect_start() -> void:
	if type == EffectType.STATUS:
		emit_signal("status_apply", status_name, true)
	if type == EffectType.STAT:
		emit_signal("effect_apply", stat_name, flat_value, percent_value)
	if type == EffectType.DOT:
		damageMachine = DamageMachine.new()
		damageMachine.attacker = applier
		match dot_name:
			DotName.BURN:
				damageMachine.raw_damage = flat_value
				damageMachine.type = DamageType.MAGIC
				damageMachine.set_crit = true
			DotName.BLEEDING:
				damageMachine.raw_damage = flat_value
				damageMachine.type = DamageType.PHYSIC
				damageMachine.set_crit = true
			DotName.POISION:
				damageMachine.percent_damage = percent_value
				damageMachine.type = DamageType.TRUE
				damageMachine.set_crit = false
			DotName.DECOMPOSITION:
				damageMachine.percent_damage = percent_value
				damageMachine.type = DamageType.MAGIC
				damageMachine.set_crit = false
		tick_timer.wait_time = tick_time
		tick_timer.one_shot = false
		_dot_cycle_run()
		tick_timer.connect("timeout", self, "_dot_cycle_run")


func _dot_cycle_run() -> void:
	if dot_name > 1:
		damageMachine.percent_heath_damage(owner)
	else:
		damageMachine.attack_received(owner)


func _effect_run_out() -> void:
	queue_free()


func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		if type == EffectType.STATUS:
			emit_signal("status_apply", status_name, false)
		if type == EffectType.STAT:
			emit_signal("effect_apply", stat_name, -flat_value, -percent_value)
		icon.queue_free()
