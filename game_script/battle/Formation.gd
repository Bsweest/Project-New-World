extends Node2D

class_name Formation

signal select_area(pos)
signal team_out(is_party)

var entityInstance = preload("res://components/battle/character.tscn")

onready var members = $Members
onready var ubLayer : UBLayer = $UBLayer

var is_party : bool
var count_member := 0
var count_death := 0

var arrChar := []

func ready_set(is_member: bool, arr: Array) -> Array:
	is_party = is_member
	ubLayer.setter(is_party, arr)

	for i in len(arr):
		var init_position = members.get_child(i)
		var newEntity : Entity = load("res://components/entity/" + arr[i]["name"] + "/model.tscn").instance()
		newEntity.c_name = arr[i]["name"]
		newEntity.is_party = is_party
		newEntity.position = init_position.position
		newEntity.pos = i
		newEntity.set_collision_layer_bit(1, false)
		newEntity.set_collision_mask_bit(1, false)
		if is_party:
			newEntity.connect("set_max_hp", owner, "_on_set_MAX_HP")
			newEntity.connect("hp_changed", owner, "_on_Char_hp_changed")
			newEntity.connect("tp_changed", owner, "_on_Char_tp_changed")
			newEntity.set_collision_layer_bit(1, true)
			newEntity.set_collision_mask_bit(2, true)
		else:
			newEntity.set_collision_layer_bit(2, true)
			newEntity.set_collision_mask_bit(1, true)
		newEntity.connect("hp_depleted", self, "_on_Char_hp_depleted")
		arrChar.append(newEntity)
		
	for each in arrChar:
		members.add_child(each)
	count_member = len(arrChar)
	return arrChar

func get_character(pos: int) -> Entity:
	return arrChar[pos]

func _active_UB(pos: int) -> void:
	var character : Entity  = get_character(pos)
	var _position = character.activeUB()
	if _position == null:
		return
	if _position == Vector2(-1, -1):
		emit_signal("select_area", pos)
		return
	ubLayer.visible = true
	ubLayer.run_ub_ani(pos, _position)

func _on_SelectArea_choose_done(pos, _position):
	ubLayer.visible = true
	var character : Entity = get_character(pos)
	character.ub_position = _position
	character.battleSprite.visible = false
	ubLayer.run_ub_ani(pos, character.position)

func _on_UB_animation_finished(pos: int) -> void:
	get_tree().paused = false
	var character : Entity = get_character(pos)
	ubLayer.visible = false
	character.UB_animation_finish()

func _on_Char_hp_depleted() -> void:
	count_death += 1
	if count_death == count_member:
		emit_signal("team_out", is_party)
