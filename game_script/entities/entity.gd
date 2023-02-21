extends KinematicBody2D

class_name Entity

enum SideEffect { NONE, BUFF, TRANSFORM }
enum DamageType { PHYSIC, MAGIC, TRUE, PIERCE, HEAL }
enum BaseClass { FIGHTER, DEFENDER, PALADIN, ARCHER, MAGE, HEALER }
enum State { RUNNING, KNOCKBACKED, LOAD_AA, SHOOT, DEATH }
enum MultipilerType { SAME, PHYSIC, MAGIC, HP }

signal hp_changed(new_hp, pos)
signal set_max_hp(max_hp, pos)
signal tp_changed(new_tp, pos)
signal hp_depleted()

var txt_dmg_number = preload("res://components/battle/DamageNumber.tscn")
var node_aa_range = preload("res://components/battle/AttackRange.tscn")
var ins_projectile = preload("res://components/battle/Projectile.tscn")

onready var stats : CharacterStats = $Stats as CharacterStats
onready var skill : CharacterSkill = $Skill as CharacterSkill
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
export var level : int = 1

var collisionDamage : DamageMachine
var attack_range : AttackRange

#?gameplay section
var can_move := true
var idle_time := 80

var state : State
var state_factory : StateFactory
var pos : int
var velocity := Vector2.ZERO
var dir := -1 # multiply with speed
var is_over := false
var max_show_time := 50
var show_health_bar := max_show_time

#?skill section
var projectile_texture : Texture
var ts : CharacterTransform
var ub_position := 0

#! Ready Set GO
func _ready() -> void:
	state_factory = StateFactory.new()
	
	set_resource()
	if !stats.is_ranged:
		battleSprite.vframes = 3
	collisionDamage = DamageMachine.new()
	collisionDamage.setter(self, stats.physic, DamageType.PHYSIC, true)
	ub.ub_set(is_party, stats, skill, self)
	hurtBox.init(is_party)
	state_idle()
	_hpBar.visible = false
	is_over = false

func state_idle() -> void:
	is_over = true
	velocity.x = 0
	_col1.set_deferred("disabled", true)
	_col2.set_deferred("disabled", true)
	battleSprite.visible = false
	idleSprite.visible = true
	animationPlayer.play("idle")

func check_death_status() -> bool:
	return state.s_name == State.DEATH

func set_resource() ->  void:
	var startStats = load("res://game_script/character_stats/resources/" + c_name + ".tres")
	var baseSkill = load("res://game_script/skills/resources/" + c_name + ".tres")

	stats.init(startStats, level)
	dir *= stats.speed
	emit_signal("set_max_hp", stats.max_hp, pos)
	_hpBar.max_value = stats.max_hp
	_hpBar.value = stats.max_hp

	if stats.is_ranged:
		projectile_texture = load("res://assets/projectile/" + stats.projectile + ".png")
		attack_range = node_aa_range.instance()
		attack_range.init(is_party, stats.c_range)
		attack_range.connect("toggle_movement", self, "_on_Movement_toggle")
		add_child(attack_range)

	skill.init(baseSkill, level)
	if skill.effect == SideEffect.TRANSFORM:
		ts = load("res://components/entity/" + c_name + "/ts.tscn").instance()
		ts.setter(is_party, stats, skill)
		ts.connect('end_transfrom', self, '_on_end_Transform')
		add_child(ts)

	if is_party:
		scale = Vector2(-1, 1)
		_hpBar.rect_scale = Vector2(-1, 1)
		dir = -dir

#// UB Layer
func activeUB() -> Vector2:
	if not skill.check_ub():
		return Vector2.ZERO
	if skill.need_choose:
		return Vector2(-1, -1)
	battleSprite.visible = false
	return position

func UB_animation_finish():
	skill.addTP(-1000)
	ub.activeUB(ub_position)
	if skill.effect == SideEffect.TRANSFORM:
		ts.activeTransform()
	else:
		battleSprite.visible = true

#* Battle Gameplay Mechanic
func normal_hit_enemy(target: Entity) -> void:
	skill.addTP(90)
	if not check_death_status():
		animationPlayer.play("attack")
	collisionDamage.modify(stats.physic)
	collisionDamage.attack_received(target)

func fire_normal_aa() -> void:
	skill.addTP(90)
	var projectile : Projectile = ins_projectile.instance()
	var dmgMachine = DamageMachine.new()
	var raw_damage : int
	var type : int
	if stats.c_class == BaseClass.MAGE || stats.c_class == BaseClass.HEALER:
		raw_damage = stats.magic
		type = DamageType.MAGIC
	else:
		raw_damage = stats.physic
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
	if damage.cal_damage == 0: 
		return
	show_health_bar = max_show_time - 1
	stats.take_calculated_dmg(damage)

func get_heal(heal: Dictionary) -> void:
	stats.take_calculated_dmg(heal)

#* Process each frame
#! check next move after attack or shoot projectile
func check_next_move() -> void:
	if state.s_name == State.SHOOT:
		fire_normal_aa()
	if can_move:
		animationPlayer.play("running")
		if state.s_name != State.RUNNING:
			change_state(State.RUNNING)
	else: 
		change_state(State.LOAD_AA)

func shot_normal() -> void:
	change_state(State.SHOOT)

func _on_Movement_toggle(move: bool) -> void:
	can_move = move

func change_state(new_state_name) -> void:
	if is_over:
		return
	if state != null:
		if check_death_status():
			return
		state.queue_free()
	state = state_factory.get_state(new_state_name).new()
	state.s_name = new_state_name
	state.setup(funcref(self, "change_state"), animationPlayer, self)
	add_child(state)

func _physics_process(_delta):
	if show_health_bar < max_show_time :
		show_health_bar -= 1
		if _hpBar.visible == false:
			_hpBar.visible = true
		if show_health_bar == 0:
			show_health_bar = max_show_time
			_hpBar.visible = false
	if idle_time > 0:
		idle_time -= 1
		if idle_time == 0:
			_col1.set_deferred("disabled", false)
			_col2.set_deferred("disabled", false)
			idleSprite.visible = false
			battleSprite.visible = true
			animationPlayer.play("running")
			change_state(State.RUNNING)

#* Signal Management
func showDamageNumber(damage: Dictionary) -> void:
	var text : DamageNumber = txt_dmg_number.instance()
	text.isPartyMember = is_party
	text.damage = damage
	add_child(text)

func _on_Stats_hp_depleted():
	_col1.set_deferred("disabled", true)
	_col2.set_deferred("disabled", true)
	if ts != null:
		ts.endTransform()
	change_state(State.DEATH)
	emit_signal("hp_depleted")

func _on_Stats_hp_changed(_new_hp: int, damage: Dictionary):
	if damage.type != DamageType.HEAL:
		skill.addTP(damage.cal_damage / stats.max_hp * 500)
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
