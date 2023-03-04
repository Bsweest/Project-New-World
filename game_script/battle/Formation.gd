extends Node2D

class_name Formation

signal select_area(pos)
signal team_out(is_party)

onready var members : Node2D = $Members
onready var _positions : Position2D = $Position
onready var ubLayer : UBLayer = $UBLayer

var is_party : bool
var count_member := 0
var count_death := 0

var arrChar := []

func ready_set(is_member: bool, arr: Array, animations: Array) -> void:
	is_party = is_member
	arrChar = arr.duplicate()
	ubLayer.setter(animations)
	for i in len(arr):
		var init_position = _positions.get_child(count_member).position
		add_character_to_formation(arrChar[i], init_position)

func remove_member_in_Formation() -> void:
	for n in members.get_children():
		members.remove_child(n)
	arrChar = []
	ubLayer.remove_ani()

func add_character_to_formation(entity: Entity, c_position: Vector2) -> void:
	count_member += 1
	entity.position = c_position
	if is_party:
		entity.connect("set_max_hp", owner, "_on_set_MAX_HP")
		entity.connect("hp_changed", owner, "_on_Char_hp_changed")
		entity.connect("tp_changed", owner, "_on_Char_tp_changed")
		entity.set_collision_layer_bit(1, true)
		entity.set_collision_mask_bit(2, true)
	else:
		entity.set_collision_layer_bit(2, true)
		entity.set_collision_mask_bit(1, true)
	entity.connect("hp_depleted", self, "_on_Char_hp_depleted")
	members.add_child(entity)

func get_character(pos: int) -> Entity:
	return arrChar[pos]

func all_idle() -> void:
	for each in arrChar:
		if each.state.s_name != 4:
			each.change_state(0)

func press_UB_button(pos: int) -> void:
	var character : Entity  = get_character(pos)
	if character.check_death_status():
		return
	var _position = character.activeUB()
	if _position == Vector2.ZERO:
		return
	if _position == Vector2(-1, -1):
		emit_signal("select_area", pos)
		return
	ubLayer.visible = true
	ubLayer.run_ub_ani(pos, _position)

func _on_SelectArea_choose_done(pos, ub_hitbox_position):
	ubLayer.visible = true
	var character : Entity = get_character(pos)
	if character.check_death_status():
		return
	character.ub_position = ub_hitbox_position
	character.battleSprite.visible = false
	ubLayer.run_ub_ani(pos, character.position, ub_hitbox_position)

func _on_UB_animation_finished(pos: int) -> void:
	get_tree().paused = false
	var character : Entity = get_character(pos)
	ubLayer.visible = false
	character.UB_animation_finish()

func _on_Char_hp_depleted() -> void:
	count_death += 1
	if count_death == count_member:
		emit_signal("team_out", is_party)
