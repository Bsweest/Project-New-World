extends CanvasLayer

class_name BattleUI

var charButton = preload("res://components/UI/UICharacterButton.tscn")

onready var _control : Control = $Control as Control

func initButton(party_member : Array) -> void: 
	for i in len(party_member):
		var init_point = _control.get_child(i)
		var button = charButton.instance()
		button.pos = i
		button.c_name = party_member[i]["name"]
		# skill icon
		button.skill_icon =  1
		button.rect_position = init_point.position
		button.connect("active_ub", get_parent(), "_active_UB_with_button")
		init_point.replace_by(button)

func set_ui_maxHP(maxHP: int, i: int):
	_control.get_child(i).set_max_hp(maxHP, i)
	_control.get_child(i).set_current_hp(maxHP)

func change_ui_hp(newHP: int, i: int) -> void:
	_control.get_child(i).set_current_hp(newHP)

func change_ui_tp(newTp: int, i: int) -> void:
	_control.get_child(i).set_current_tp(newTp)
