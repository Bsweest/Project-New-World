extends CharacterTransform

enum StatChange { PHYSIC, MAGIC, P_DEFENSE, M_ARMOR, CRIT_C, CRIT_DMG, SPEED, DMG_MOD, TP_MOD }

const DURATION_TIME := 30
var running_time := 30
var open_TS_hitbox := false

var damageMachine : DamageMachine = DamageMachine.new()

func _ready():
	# warning-ignore:return_value_discarded
	stats.connect("stat_changed", self, "_on_Stat_stat_changed")
	damageMachine.setter(owner, int(skill.side_dmg * stats.get_magic() / 100), 1, false)
	_hitbox.setter(damageMachine, true)

func _on_Stat_stat_changed(name: int):
	if name == StatChange.MAGIC:
		damageMachine.modify(int(skill.side_dmg * stats.get_magic() / 100))

func _process(_delta) -> void:
	if not is_active:
		return
	#? toggle hit box
	running_time -= 1
	if running_time > 0:
		return
	#? When running time hit 0, toggle collision
	if open_TS_hitbox:
		_hitbox.enable_collision()
		open_TS_hitbox = false
	else:
		_hitbox.disable_collision()
		open_TS_hitbox = true
	running_time = DURATION_TIME
