extends KinematicBody2D

class_name Entity

enum DamageType { PHYSIC, MAGIC, TRUE, PIERCE, HEAL }
enum BaseClass { FIGHTER, DEFENDER, PALADIN, ARCHER, MAGE, HEALER }
enum State { IDLE, RUNNING, KNOCKBACKED, LOAD_AA, SHOOT, DEATH, CC_ED }
enum MultipilerType { SAME, PHYSIC, MAGIC, HP }
enum StatChange { PHYSIC, MAGIC, P_DEFENSE, M_ARMOR, CRIT_C, CRIT_DMG, SPEED, DMG_MOD, TP_MOD }
enum StatusName  { IMMUNE, CURSE, SILENT, STUN, FREEZE, SHOCK }

signal hp_changed(new_hp, pos)
signal set_max_hp(max_hp, pos)
signal tp_changed(new_tp, pos)
signal hp_depleted()

var txt_dmg_number = preload("res://components/battle/DamageNumber.tscn")
var node_aa_range = preload("res://components/battle/AttackRange.tscn")
var ins_projectile = preload("res://components/battle/Projectile.tscn")

onready var stats : CharacterStats = $Stats as CharacterStats
onready var skill : CharacterSkill = $Skill as CharacterSkill
onready var effectMachine : EffectMachine = $Effect as EffectMachine
onready var _hpBar : ProgressBar = $HPBar
onready var hurtBox : HurtBox = $HurtBox as HurtBox
onready var battleSprite : Sprite = $InBattle as Sprite
onready var idleSprite : Sprite = $Idle as Sprite
onready var animationPlayer : AnimationPlayer = $AnimationPlayer as AnimationPlayer
onready var ub : NodeUB = $NodeUB
onready var _col1 := $HurtBox/CollisionShape2D
onready var _col2 := $CollisionBody

export var c_name: String
export var is_party : bool = true
export var level : int = 10

var collisionDamage : DamageMachine = DamageMachine.new()
var attack_range : AttackRange

#?gameplay section
var can_range_move := true
var idle_time := 80

var state : State
var state_factory : StateFactory = StateFactory.new()
var pos : int
var is_stunned := 0 

var movement_speed : int = 0 setget set_movement ,get_movement
var party_direction : int = -1

var is_over := false
const MAX_BAR_SHOW_TIME := 50
var show_health_bar := MAX_BAR_SHOW_TIME

#?skill section
var projectile_texture : Texture
var ub_position := 0

#! Ready Set GO
func _ready() -> void:
	set_resource()
	collisionDamage.setter(self, stats.get_physic(), DamageType.PHYSIC, true)
	ub.ub_set(is_party, stats, skill, self)
	hurtBox.init(is_party)
	change_state(State.IDLE)
	_hpBar.visible = false
	is_over = false

func out_of_game_loop() -> void:
	is_over = true
	_col1.set_deferred("disabled", true)
	_col2.set_deferred("disabled", true)
	animationPlayer.play("idle")

func remove_idle_animation() -> void:
	idleSprite.visible = false
	battleSprite.visible = true

func check_death_status() -> bool:
	return state.s_name == State.DEATH

func set_resource() ->  void:
	var startStats = load("res://game_script/character_stats/resources/" + c_name + ".tres")
	if not skill.has_no_skill:
		var baseSkill = load("res://game_script/skills/resources/" + c_name + ".tres")
		skill.init(baseSkill, level)

	stats.init(startStats, level)
	emit_signal("set_max_hp", stats.max_hp, pos)
	_hpBar.max_value = stats.max_hp
	_hpBar.value = stats.max_hp
	create_attack_range()
	effectMachine.setter(self, is_party, pos, stats)
	
	if is_party:
		scale = Vector2(-1, 1)
		_hpBar.rect_scale = Vector2(-1, 1)
		party_direction = 1
	set_movement(stats.get_speed())

func create_attack_range() -> void:
	if stats.is_ranged:
		projectile_texture = load("res://assets/projectile/" + stats.projectile + ".png")
		attack_range = node_aa_range.instance()
		attack_range.init(is_party, stats.c_range)
		attack_range.connect("toggle_movement", self, "_on_Movement_toggle")
		add_child(attack_range)


#// UB Layer
func change_tp(num: int) -> void:
	num = int(num * stats.get_tp_boost())
	skill.addTP(num)

func activeUB() -> Vector2:
	# if not skill.check_ub():
	# 	return Vector2.ZERO
	if skill.need_choose:
		return Vector2(-1, -1)
	battleSprite.visible = false
	return position

func UB_animation_finish():
	skill.addTP(-1000)
	ub.activeUB(ub_position)
	battleSprite.visible = true

#* Movement control
func set_movement(num: int) -> void:
	movement_speed = party_direction * num
func get_movement() -> int:
	return movement_speed

func get_stun_status() -> bool:
	return bool(is_stunned)

func check_has_status(name: int) -> bool:
	return effectMachine.affected_status.has(name)

#* Battle Gameplay Mechanic
func _on_Stats_stat_changed(name: int):
	if name == StatChange.PHYSIC:
		collisionDamage.modify(stats.get_physic())
	if name == StatChange.SPEED:
		set_movement(stats.get_speed())

func normal_hit_enemy(target: Entity) -> void:
	if get_stun_status():
		return
	change_tp(90)
	if not check_death_status():
		animationPlayer.play("attack")
	collisionDamage.attack_received(target)

func fire_normal_aa() -> void:
	change_tp(90)
	var projectile : Projectile = ins_projectile.instance()
	var dmgMachine = DamageMachine.new()
	var raw_damage : int
	var type : int
	if stats.c_class == BaseClass.MAGE || stats.c_class == BaseClass.HEALER:
		raw_damage = stats.get_magic()
		type = DamageType.MAGIC
	else:
		raw_damage = stats.get_physic()
		type = DamageType.PHYSIC
	dmgMachine.setter(self, raw_damage, type, true)
	projectile.projectile_setter(is_party, projectile_texture, dmgMachine, true)
	add_child(projectile)

func fire_special_projectile(_txt: Texture, dmgMachine: DamageMachine, isKB: bool, modSpeed: float, numTarget: int) -> void:
	var projectile : Projectile = ins_projectile.instance()
	projectile.projectile_setter(is_party, _txt, dmgMachine, isKB)
	projectile.modify_projectile(modSpeed, numTarget)
	add_child(projectile)
	
func take_damage(damage: Dictionary) -> void:
	show_health_bar = MAX_BAR_SHOW_TIME - 1
	stats.take_calculated_dmg(damage)

func get_heal(heal: Dictionary) -> void:
	stats.take_calculated_dmg(heal)

#* Process each frame
#! check next move after attack or shoot projectile
func check_next_move() -> void:
	if state.s_name == State.SHOOT:
		fire_normal_aa()
	if can_range_move:
		animationPlayer.play("running")
		if state.s_name != State.RUNNING:
			change_state(State.RUNNING)
	else: 
		change_state(State.LOAD_AA)

func shot_normal() -> void:
	change_state(State.SHOOT)

func _on_Movement_toggle(move: bool) -> void:
	can_range_move = move

func can_go_next_state(new_state_name: int) -> bool:
	if not get_stun_status():
		return true
	if new_state_name == State.DEATH || new_state_name == State.CC_ED:
		return true
	if new_state_name == State.KNOCKBACKED:
		if check_has_status(StatusName.FREEZE):
			return false
		return true
	return false

func change_state(new_state_name: int) -> void:
	if is_over:
		return
	if state != null:
		if not can_go_next_state(new_state_name):
			return
		if check_death_status():
			return #// If alive then process to next state
		state.queue_free()
	state = state_factory.get_state(new_state_name).new()
	state.s_name = new_state_name
	state.setup(funcref(self, "change_state"), animationPlayer, self)
	add_child(state)

func _physics_process(_delta):
	if show_health_bar < MAX_BAR_SHOW_TIME :
		show_health_bar -= 1
		if _hpBar.visible == false:
			_hpBar.visible = true
		if show_health_bar == 0:
			show_health_bar = MAX_BAR_SHOW_TIME
			_hpBar.visible = false
	if idle_time > 0:
		idle_time -= 1
		if idle_time == 0:
			_col1.set_deferred("disabled", false)
			_col2.set_deferred("disabled", false)
			remove_idle_animation()
			animationPlayer.play("running")
			change_state(State.RUNNING)

#* Signal Management
func showDamageNumber(damage: Dictionary) -> void:
	var text : DamageNumber = txt_dmg_number.instance()
	text.isPartyMember = is_party
	text.damage = damage
	add_child(text)

func set_stun_state(value: bool) -> void:
	if value:
		is_stunned += 1
		change_state(State.CC_ED)
	else:
		is_stunned -= 1
	if is_stunned == 0:
		remove_idle_animation()
		if state.s_name == State.CC_ED:
			change_state(State.RUNNING)

func _on_CC_status_applied(status_name: int, is_increase: bool) -> void:
	effectMachine.add_affected_status_to_Arr(status_name, is_increase)
	if status_name >= StatusName.STUN:
		set_stun_state(is_increase)

func _on_Stats_hp_depleted():
	_col1.set_deferred("disabled", true)
	_col2.set_deferred("disabled", true)
	ub._on_character_death()
	change_state(State.DEATH)
	emit_signal("hp_depleted")

func _on_Stats_hp_changed(_new_hp: int, damage: Dictionary):
	if damage.type != DamageType.HEAL:
		change_tp(damage.cal_damage / stats.max_hp * 500 * stats.get_tp_boost())
	_hpBar.value = _new_hp
	showDamageNumber(damage)
	if is_party:
		emit_signal("hp_changed", _new_hp, pos)

func _on_Skill_add_tp(newTP: int):
	if is_party:
		emit_signal("tp_changed", newTP, pos)

func get_class() -> String: return "Entity"

#* Skill Side Effect
func _on_end_Transform() -> void:
	battleSprite.visible = true

func get_added_effect(new_effect) -> void:
	effectMachine.add_effect_to_Body(new_effect)
