extends Node

class_name CharacterSkill

signal add_tp(newTP)

const fullUB = 1000

var current_tp : int = 0

var skill_name : String
var skill_description : String
var base_dmg : int
var percent_hp : int
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
	percent_hp = skill.percent_hp
	type = skill.type
	multipiler_type = skill.multipiler_type
	effect = skill.side_effect
	need_choose = skill.need_choose

func addTP(amount: int) -> void:
	current_tp += amount
	current_tp = max(0, current_tp)
	if current_tp > 1000:
		current_tp = 1000
	emit_signal("add_tp", current_tp)

func check_ub() -> bool:
	if current_tp == 1000:
		return true
	return false
