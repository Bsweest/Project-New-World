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

func _ready() -> void:
	state_factory = StateFactory.new()
	set_resource()
	if !stats.is_ranged:
		battleSprite.vframes = 3
	ub.ready_set(is_party, stats, skill)
	hurtBox.init(is_party)
	state_idle()
	_hpBar.visible = false
	is_over = false

func state_idle() -> void:
	is_over = true
	velocity.x = 0
	battleSprite.visible = false
	idleSprite.visible = true
	animationPlayer.play("idle")

func set_resource() ->  void:
	if c_name == null :
		queue_free()
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
	ub.activeUB(ub_position)
	skill.addTP(-1000)
	if skill.effect == SideEffect.TRANSFORM:
		ts.activeTransform()
	else:
		battleSprite.visible = true

#* Battle Gameplay Mechanic
func normal_hit_enemy(target: Entity) -> void:
	skill.addTP(90)
	if !state.s_name == State.DEATH:
		animationPlayer.play("attack")
	var is_crit = Utils.isCrit(stats.crit_c)
	var dmg : int = stats.physic
	if is_crit: 
		dmg *= stats.crit_dmg
	target.take_damage(dmg, is_crit, DamageType.PHYSIC)

func fire_normal_aa() -> void:
	skill.addTP(90)
	var projectile : Projectile = ins_projectile.instance()
	projectile._texture =  projectile_texture
	
	if stats.c_class == BaseClass.MAGE || stats.c_class == BaseClass.HEALER:
		projectile.dmg = stats.magic
		projectile.type = DamageType.MAGIC
	else:
		projectile.dmg = stats.physic
		projectile.type = DamageType.PHYSIC
	projectile.is_crit = Utils.isCrit(stats.crit_c)
	if projectile.is_crit:
		projectile.dmg *= stats.crit_dmg
	projectile.is_party = is_party
	projectile.is_kb = true
	add_child(projectile)

func fire_special_projectile(_txt: Texture, damage: int, type: int, isKB: bool) -> void:
	var projectile : Projectile = ins_projectile.instance()
	projectile._texture =  _txt
	projectile.dmg = damage
	projectile.type = type
	projectile.is_crit = Utils.isCrit(stats.crit_c)
	if projectile.is_crit:
		projectile.dmg *= stats.crit_dmg
	projectile.is_party = is_party
	projectile.is_kb = isKB
	add_child(projectile)
	
func take_damage(amount: int, is_crit: bool, type: int) -> void:
	if amount == 0: 
		return
	show_health_bar = max_show_time - 1
	var mul = stats.defense_multiplier(type)
	amount *= mul
	stats.take_dmg(amount, is_crit, type)

func get_heal(amount: int) -> void:
	stats.take_dmg(-amount, false, DamageType.HEAL)

func _on_Stats_hp_depleted():
	_col1.set_deferred("disabled", true)
	_col2.set_deferred("disabled", true)
	if ts != null:
		ts.endTransform()
	change_state(State.DEATH)
	if pos != null:
		emit_signal("hp_depleted")

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
		if state.s_name == State.DEATH:
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
			idleSprite.visible = false
			battleSprite.visible = true
			animationPlayer.play("running")
			change_state(State.RUNNING)

#* Signal Management
func showDamageNumber(amount: int, is_crit: bool, type: int) -> void:
	var text : DamageNumber = txt_dmg_number.instance()
	text.amount = amount
	text.isPartyMember = is_party
	text.is_crit = is_crit
	text.type = type
	add_child(text)

func _on_Stats_hp_changed(_new_hp: int, amount: int, is_crit: bool, type: int):
	skill.addTP(amount / stats.max_hp * 500)
	_hpBar.value = _new_hp
	showDamageNumber(amount, is_crit, type)
	if is_party:
		emit_signal("hp_changed", _new_hp, pos)

func _on_Skill_add_tp(newTP: int):
	if is_party:
		emit_signal("tp_changed", newTP, pos)

func get_class() -> String: return "Entity"

#* Skill Side Effect
func _on_end_Transform() -> void:
	battleSprite.visible = true

