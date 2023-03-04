extends Node2D

signal end_game(boolean)
signal hp_changed(new_hp, pos)
signal set_max_hp(max_hp, pos)
signal tp_changed(new_tp, pos)

class_name BattleManager

onready var battleScene : Node2D = $FormationNode as Node2D
onready var selectArea : UISelectArea = $SelectArea
onready var party_formation : Formation = $FormationNode/PartyFormation
var enemy_formation : Formation

var is_winning : bool
var is_over := false

var timer = Timer.new()

func _ready():
	initEnemiesFormation()
	timer.wait_time = 1
	timer.one_shot = true
	timer.connect("timeout", self, "_timer_out")
	add_child(timer)

func initEnemiesFormation() -> void:
	enemy_formation = load("res://components/battle/formation/NormalEnemyFormation.tscn").instance()
	enemy_formation.connect("team_out", self, "_on_Formation_team_out")
	party_formation.connect("team_out", self, "_on_Formation_team_out")
	battleScene.add_child(enemy_formation)

func field_characters(arrAlly: Array, arrEnemy: Array, ub_team, ub_opponent) -> void: 
	party_formation.ready_set(true, arrAlly, ub_team)
	enemy_formation.ready_set(false, arrEnemy, ub_opponent)
	for each in arrAlly:
		each.ub.setup_formation(arrAlly, arrEnemy)
	for each in arrEnemy:
		each.ub.setup_formation(arrAlly, arrEnemy)

#* Battle Result
func _on_Formation_team_out(is_party: bool):
	if is_over:
		return
	is_over = true
	party_formation.all_idle()
	enemy_formation.all_idle()
	is_winning = !is_party
	timer.start()

func _timer_out() -> void:
	emit_signal("end_game", is_winning)

#* Show Stat
func _on_Char_hp_changed(new_hp: int, pos: int) -> void:
	emit_signal("hp_changed", new_hp, pos)

func _on_Char_tp_changed(new_tp: int, pos: int) -> void:
	emit_signal("tp_changed", new_tp, pos)

func _on_set_MAX_HP(max_hp: int, pos: int) -> void:
	emit_signal("set_max_hp", max_hp, pos)
