extends Control

class_name ButtonUB

signal active_ub(pos)

onready var btn_active : Button = $Button
onready var illustration : TextureRect = $Panel/MarginContainer/Illustration
onready var hpBar : ProgressBar = $HPBar
onready var tpBar : TextureProgress = $TPBar
onready var icon_skill : TextureRect = $TPBar/SkillIcon
onready var container_effect : GridContainer = $EffectContainer

var pos : int
var character_name : String
var icon_name : int
var action_name : String = ""

var mold = 65 / 255.0
var under = Color(mold, mold, mold)
var fully = Color(1, 1, 1)

func setter_button(index: int, c_name: String, i_name: int) -> void:
	pos = index
	action_name = "ub_pos_" + str(pos + 1)
	character_name = c_name
	icon_name = i_name

func _ready() -> void:
	Utils.connect("buff_changed", self, "_add_status_effect")
	var spriteImg = load("res://assets/sprite/" + character_name +"/illustration.png")
	var skillIcon = load("res://assets/skills/skill_icon" + str(1)  + ".png")
	illustration.set_texture(spriteImg)
	icon_skill.set_texture(skillIcon)
	icon_skill.modulate = under
	tpBar.max_value = 1000

func set_max_hp(value: int) -> void:
	hpBar.max_value = value

func set_current_hp(value: int) -> void:
	hpBar.value = value
	if value == 0:
		modulate = under

func set_current_tp(value: int) -> void:
	if tpBar.value == 1000 && value == 0:
		icon_skill.modulate = under
	tpBar.value = value
	if value == 1000 && icon_skill.modulate != fully:
		icon_skill.modulate = fully

func _on_Button_pressed():
	emit_signal("active_ub", pos)

func _add_status_effect(index: int, icon: StatusEffectIcon) -> void:
	if index == pos:
		container_effect.add_child(icon)

func _input(event: InputEvent):
	if event.is_action_pressed(action_name):
		_on_Button_pressed()
		
