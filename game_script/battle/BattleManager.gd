extends Node2D

class_name BattleManager

signal end_game(boolean)

onready var battleScene : Node2D = $FormationNode as Node2D
onready var ui : BattleUI = $UIBattle as BattleUI
onready var selectArea : UISelectArea = $SelectArea
onready var party_formation = $FormationNode/PartyFormation
var enemy_formation

var arrAlly : Array
var arrEnemy : Array
var count_allies := 0
var is_winning : bool

var timer = Timer.new()

func _ready():
	var ally = [
		# { 
		# 	"name": "mezuna_ryuji", 
		# 	"skill_icon": 4
			
		# },
		{ 
			"name": "mob_shooter_1",
			"skill_icon": 1
		},
		{ 
			"name": "mezuna_ryuji",
			"skill_icon": 1
		}
		]
	var enemy = [
		# {
		# 	"name": "hoa_lan",
		# 	"skill_icon": 1
		# },
		{ 
			"name": "thanh_dung",
			"skill_icon": 1
		}
		]
	
	ui.initButton(ally)
	initEnemiesFormation()
	field_characters(ally, enemy)
	timer.wait_time = 1
	timer.one_shot = true
	timer.connect("timeout", self, "_timer_out")
	add_child(timer)

func initEnemiesFormation() -> void:
	enemy_formation = load("res://components/battle/formation/5EnemiesFormation.tscn").instance()
	enemy_formation.connect("team_out", self, "_on_Formation_team_out")
	party_formation.connect("team_out", self, "_on_Formation_team_out")
	battleScene.add_child(enemy_formation)

func field_characters(party_member: Array, enemies: Array) -> void: 
	arrAlly = party_formation.ready_set(true, party_member)
	arrEnemy = enemy_formation.ready_set(false, enemies)
	count_allies = len(arrAlly)
	for each in arrAlly:
		set_both_formation(true, each.pos)
	for each in arrEnemy:
		set_both_formation(false, each.pos)

func set_both_formation(is_party: bool, pos: int) -> void:
	if is_party:
		party_formation.get_character(pos).ub.setup_formation(arrAlly, arrEnemy)
	else:
		enemy_formation.get_character(pos).ub.setup_formation(arrEnemy, arrAlly)

#* Battle Result
func _on_Formation_team_out(is_party: bool):
	party_formation.all_idle()
	enemy_formation.all_idle()
	is_winning = !is_party
	timer.start()

func _timer_out() -> void:
	emit_signal("end_game", is_winning)

#* Show Stat
func _on_Char_hp_changed(_new_hp: int, pos: int) -> void:
	ui.change_ui_hp(_new_hp, pos)

func _on_Char_tp_changed(_new_hp: int, pos: int) -> void:
	ui.change_ui_tp(_new_hp, pos)

func _on_set_MAX_HP(_max_hp: int, pos: int) -> void:
	ui.set_ui_maxHP(_max_hp, pos)

#* Input event
func _active_UB_with_button(pos: int) -> void:
	party_formation._active_UB(pos)

func _input(event: InputEvent):
	if event.is_action_pressed("ub_pos_1"):
		if count_allies > 0:
			party_formation._active_UB(0)
	if event.is_action_pressed("ub_pos_2"):
		if count_allies > 1:
			party_formation._active_UB(1)
	if event.is_action_pressed("ub_pos_3"):
		if count_allies > 2:
			party_formation._active_UB(2)
	if event.is_action_pressed("ub_pos_4"):
		if count_allies > 3:
			party_formation._active_UB(3)
	if event.is_action_pressed("ub_pos_5"):
		if count_allies > 4:
			party_formation._active_UB(4)
