extends Node

class_name CharacterSkill

signal add_tp(newTP)

const fullUB = 1000

var current_tp : int = 0

var skill_name : String
var skill_description : String
var base_dmg : int
var side_dmg : int
var type : int
var multipiler_type : int
var effect : int
var need_choose : bool

func init(skill: BaseSkill, lvl: int) -> void:
	skill_name = skill.skill_name
	skill_description = skill.skill_description
	base_dmg = skill.base_dmg
	side_dmg = skill.side_dmg
	type = skill.type
	multipiler_type = skill.multipiler_type
	need_choose = skill.need_choose

func addTP(amount: int) -> void:
	current_tp += amount
	current_tp = int(max(0, current_tp))
	current_tp = int(min(1000, current_tp))
	emit_signal("add_tp", current_tp)

func check_ub() -> bool:
	if current_tp == 1000:
		return true
	return false
