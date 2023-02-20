extends NodeUB

class_name NodeUBArea

onready var _hitbox : HitBox = $HitBox
onready var _coll : CollisionShape2D = $HitBox/CollisionShape2D

var first_use := false
var is_active := false
var running_time := 6

func ub_set(isParty: bool, c_stats: CharacterStats, c_skill: CharacterSkill, _character) -> void:
	.ub_set(isParty, c_stats, c_skill, _character)
	_hitbox.initHitbox(is_party)
	_hitbox.disable_collision()

func _ready() -> void:
	_hitbox.setter(damageMachine, true)

func activeUB(ub_postion: int) -> void:
	if ub_postion != 0:
		_hitbox.global_position = Vector2(ub_postion, 250)
	if !first_use:
		first_use = true
		_hitbox.scale = Vector2(1, 1)
	var newDMg = calc_skill_damage()
	damageMachine.modify(newDMg)
	_hitbox.enable_collision()
	is_active = true

func after_ub_effect() -> void:
	pass

func _physics_process(_delta) -> void:
	if not is_active:
		return
	running_time -= 1
	if running_time == 0:
		is_active = false
		after_ub_effect()
		_hitbox.disable_collision()
		running_time = 6
