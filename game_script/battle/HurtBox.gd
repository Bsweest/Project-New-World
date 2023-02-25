extends Area2D

class_name HurtBox

var mercy_cooldown = []

func _init():
	set_collision_layer_bit(1, false)
	set_collision_mask_bit(1, false)

func _ready() -> void:
	# warning-ignore:return_value_discarded
	connect("area_entered", self, "_on_Area_enter")
	# warning-ignore:return_value_discarded
	connect("body_entered", self, "_on_Body_enter")

func init(is_party: bool) -> void:
	var mask  = 1
	if is_party:
		mask = 2
	set_collision_mask_bit(mask, true)

func _on_Area_enter(box: HitBox) -> void:
	if box.is_kb:
		owner.change_state(2)
	box.dmgMachine.attack_received(owner)

func _on_Body_enter(body) -> void:
	if body.get_class() != "Entity":
		return
	owner.change_state(2)
	body.normal_hit_enemy(owner)
