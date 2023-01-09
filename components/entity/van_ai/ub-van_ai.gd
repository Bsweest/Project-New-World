extends NodeUB

var num_enemy := 0

func _on_HitBox_body_entered(body):
	if body.get_class() == "Entity":
		num_enemy += 1

func activeUB(ub_postion: int) -> void:
	num_enemy = 0
	.activeUB(ub_postion)

func _do_UB_skill() -> void:
	_hitbox.disable_collision()
	var amount : int = int(skill.side_dmg * stats.magic * (1 + 0.3 * num_enemy) / 100)
	for each in members:
		each.get_heal(amount)
