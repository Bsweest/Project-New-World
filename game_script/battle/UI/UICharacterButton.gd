extends Control

class_name ButtonUB

signal active_ub(pos)

onready var skillRect : TextureRect = $TextureRect as TextureRect
onready var textureImg : TextureRect = $UImain/Panel/TextureRect as TextureRect
onready var hpBar : ProgressBar = $HPBar
onready var tpBar : TextureProgress = $TPBar

var pos : int
var c_name : String
var skill_icon : int

var mold = 65 / 255.0
var under = Color(mold, mold, mold)
var fully = Color(1, 1, 1)

func _ready() -> void:
	var spriteImg = load("res://assets/sprite/" + c_name +"/illustration.png")
	var skillIcon = load("res://assets/skills/skill_icon" + str(skill_icon)  + ".png")
	textureImg.set_texture(spriteImg)
	skillRect.set_texture(skillIcon)
	tpBar.max_value = 1000.0
	skillRect.modulate = under

func set_max_hp(value: int, _pos: int) -> void:
	hpBar.max_value = value
	pos = _pos

func set_current_hp(value: int) -> void:
	hpBar.value = value
	if value == 0:
		modulate = under

func set_current_tp(value: int) -> void:
	tpBar.value = value
	if(value == 1000):
		skillRect.modulate = fully

func _on_Button_pressed():
	emit_signal("active_ub", pos)
