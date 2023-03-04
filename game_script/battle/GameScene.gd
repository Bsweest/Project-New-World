extends Node

class_name GameScene

onready var _container : ViewportContainer = $ViewportContainer
onready var _viewport : Viewport = $ViewportContainer/Viewport
onready var ui_battle : BattleUI = $UIBattle
onready var ui_control : UIControl = $UIControl
onready var battle_manager : BattleManager = $ViewportContainer/Viewport/BattleManager
onready var area_choose : UISelectArea = $ViewportContainer/Viewport/BattleManager/SelectArea

onready var screen_res = get_viewport().size
var scaling = Vector2.ZERO

var data_ally : Array setget set_arr_ally
var data_wave1 : Array
var data_wave2 : Array
var data_wave3 : Array

var arrAlly : Array
var arrEnemy : Array

var ub_ani_ally : Array
var ub_ani_enemy : Array

var current_wave = 1

func _ready():
	randomize()
	scaling = screen_res / _viewport.size
	_container.rect_scale = scaling
	set_arr_ally([])
	set_arr_wave_enemy([])
	ui_battle.ready_set(data_ally)
	battle_manager.field_characters(arrAlly, arrEnemy, ub_ani_ally, ub_ani_enemy)

func _active_UB_with_button(pos: int) -> void:
	battle_manager.party_formation.press_UB_button(pos)


func _on_BattleManager_end_game(is_winning: bool):
	if not is_winning:
		ui_control._on_End_game(false)
		return
	# Go to Next Wave
	if false:
		battle_manager.party_formation.remove_member_in_Formation()
		battle_manager.enemy_formation.remove_member_in_Formation()
	# All wave clean
	ui_control._on_End_game(true)
	

func set_arr_ally(data: Array) -> void:
	var ally = [
		# {
		# 	"name": "0",
		# },
		{ 
			"name": "thanh_dung",
		},
		{ 
			"name": "van_ai",
		}
	]
	data_ally = ally
	for each in data_ally:
		create_entity(arrAlly, ub_ani_ally, each["name"], true)

func set_arr_wave_enemy(_i) -> void:
	var enemy = [
		{
			"name": "mob_shooter_1",
		},
		# { 
		# 	"name": "thanh_dung",
		# },
		{ 
			"name": "mob_fighter_1",
		},
	]
	data_wave1 = enemy
	for each in data_wave1:
		create_entity(arrEnemy, ub_ani_enemy, each["name"], false)

func create_entity(arr: Array, animations: Array, c_name: String, is_party: bool) -> void:
	var index = len(arr)
	var newEntity : Entity = load("res://components/entity/" + c_name + "/model.tscn").instance()
	newEntity.pos = index
	newEntity.c_name = c_name
	newEntity.is_party = is_party
	arr.append(newEntity)
	# UB Animation
	var ani : AnimationUB = null
	var path = "res://components/entity/" + c_name + "/ub_ani.tscn"
	var directory = Directory.new()
	if directory.file_exists(path):
		var baseSkill : BaseSkill = load("res://game_script/skills/resources/" + c_name + ".tres")
		ani = load(path).instance()
		if is_party: 
			ani.scale = Vector2(-1, 1)
		ani.pos = index
		ani.is_party = is_party
		ani.skill_name = baseSkill.skill_name
	animations.append(ani)
