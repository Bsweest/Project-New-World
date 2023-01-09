extends Node2D

class_name BattleManager

var entityInstance = preload("res://components/battle/character.tscn")

onready var battleScene : Node2D = $FormationNode as Node2D
onready var ui : BattleUI = $UIBattle as BattleUI
onready var selectArea : UISelectArea = $SelectArea
onready var uiControl : UIControl = $UIControl
onready var party_formation = $FormationNode/PartyFormation
var enemy_formation


var arrAlly : Array
var arrEnemy : Array
var count_allies := 0

func _ready():
	var ally = [
		{ 
			"name": "mezuna_ryuji", 
			"skill_icon": 4
			
		},
		{ 
			"name": "van_ai",
			"skill_icon": 1
		}
		]
	var enemy = [
		{ 
			"name": "hoa_lan",
			"skill_icon": 1
		},
		{ 
			"name": "thanh_dung",
			"skill_icon": 1
		}
		]
	
	ui.initButton(ally)
	initEnemiesFormation()
	field_characters(ally, enemy)

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
		if each.skill.need_formation:
			return_both_formation(true, each.pos)
	for each in arrEnemy:
		if each.skill.need_formation:
			return_both_formation(false, each.pos)

func return_both_formation(is_party: bool, pos: int) -> void:
	if is_party:
		party_formation.get_character(pos).ub.setup_formation(arrAlly, arrEnemy)
	else:
		enemy_formation.get_character(pos).ub.setup_formation(arrEnemy, arrAlly)

#* Battle Result
func _on_Formation_team_out(is_party):
	uiControl._on_End_game(!is_party)

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
