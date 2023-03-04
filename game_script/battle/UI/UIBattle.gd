extends CanvasLayer

class_name BattleUI

var charButton = preload("res://components/UI/UICharacterButton.tscn")

onready var _control : Control = $Control as Control
onready var _positions : Position2D = $Positions

var button_index := 0

func ready_set(arr: Array) -> void:
	for each in arr:
		create_button(each["name"])

func create_button(c_name : String) -> void: 
	var init_point = _positions.get_child(button_index)
	var button : ButtonUB = charButton.instance()
	button.setter_button(button_index, c_name, 1)
	button.rect_position = init_point.position
	button.connect("active_ub", get_parent(), "_active_UB_with_button")
	button_index += 1
	_control.add_child(button)

func _on_BattleManager_tp_changed(new_tp: int, pos: int):
	_control.get_child(pos).set_current_tp(new_tp)

func _on_BattleManager_set_max_hp(max_hp: int, pos: int):
	_control.get_child(pos).set_max_hp(max_hp)

func _on_BattleManager_hp_changed(new_hp: int, pos: int):
	_control.get_child(pos).set_current_hp(new_hp)
