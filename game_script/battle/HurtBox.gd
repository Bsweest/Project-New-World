extends Area2D

class_name HurtBox

const MERCY_COOLDOWN := 15
var opponent_in_area := {}

func _init():
	set_collision_layer_bit(1, false)
	set_collision_mask_bit(1, false)

func _ready() -> void:
	pass
	
func init(is_party: bool) -> void:
	var mask = 1
	if is_party:
		mask = 2
	set_collision_mask_bit(mask, true)

func _on_Area_enter(box: HitBox) -> void:
	if box.is_kb:
		owner.change_state(2)
	box.dmgMachine.attack_received(owner)

func _on_Body_enter(body) -> void:
	opponent_in_area[body] = 0
	if not body.get_stun_status():
		owner.change_state(2)
		body.normal_hit_enemy(owner)

func _on_HurtBox_body_exited(body):
	opponent_in_area.erase(body)

func _physics_process(_delta):
	if opponent_in_area.size() == 0:
		return
	var arr = opponent_in_area.keys()
	for each in arr:
		opponent_in_area[each] += 1
		if opponent_in_area[each] >= MERCY_COOLDOWN:
			if not each.get_stun_status():
				owner.change_state(2)
				each.normal_hit_enemy(owner)
				opponent_in_area[each] = 0

func get_class() -> String: return "HurtBox"
