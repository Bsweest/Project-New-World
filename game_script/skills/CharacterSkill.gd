extends Node

class_name CharacterSkill

signal add_tp(newTP)

export var has_no_skill := false
export var need_choose := false

const FULL_UB = 1000
var current_tp : int = 0

var skill_name : String
var base_dmg : int
var side_dmg : int
var type : int
var multipiler_type : int
var effect : int

func init(skill: BaseSkill, lvl: int) -> void:
	skill_name = skill.skill_name
	base_dmg = skill.base_dmg
	side_dmg = skill.side_dmg
	type = skill.type
	multipiler_type = skill.multipiler_type

func addTP(amount: int) -> void:
	current_tp += amount
	current_tp = int(max(0, current_tp))
	current_tp = int(min(1000, current_tp))
	emit_signal("add_tp", current_tp)

func check_ub() -> bool:
	if current_tp == FULL_UB:
		return true
	return false
