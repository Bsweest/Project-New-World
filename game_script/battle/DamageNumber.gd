extends Position2D

class_name DamageNumber

enum DamageType { PHYSIC, MAGIC, TRUE, PIERCE, HEAL }

onready var label: Label = $Label as Label
onready var tween: Tween = $Tween as Tween

var damage: Dictionary
var isPartyMember : bool
var amount := 0
var is_crit : bool = false
var type : int

var _velocity = Vector2(0, 80)

func _ready() -> void:
	var end = Vector2(1, 1)
	var pre_fix = "-"
	amount = damage.cal_damage
	is_crit = damage.is_crit
	type = damage.type
	if isPartyMember : 
		scale = Vector2(-0.7, 0.7)
		end = Vector2(-1, 1)
	#Physic
	if is_crit:
		label.add_color_override("font_color", Color(255/255.0, 90/255.0, 3/255.0))
	#Magic
	if type == DamageType.MAGIC:
		if is_crit:
			label.add_color_override("font_color", Color(136/255.0, 14/255.0, 212/255.0))
		else:
			label.add_color_override("font_color", Color(224/255.0, 135/255.0, 255/255.0))
	elif type == DamageType.HEAL:
		label.add_color_override("font_color", Color(15/255.0, 255/255.0, 80/255.0))
		pre_fix = "+"
		amount = -amount
	elif type == DamageType.TRUE:
		label.add_color_override("font_color", Color(1, 1, 1))
	label.set_text(pre_fix + str(amount))
	tween.interpolate_property(self, 'scale', scale, end, 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.7)
	tween.start()

	
func _process(_delta) -> void:
	position -= _velocity * _delta

func _on_Tween_tween_all_completed():
	queue_free()
