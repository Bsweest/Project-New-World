extends NodeUBArea

var num_enemy := 0

func _on_HitBox_body_entered(body):
	if body.get_class() == "Entity":
		num_enemy += 1

func activeUB(ub_postion: int) -> void:
	num_enemy = 0
	.activeUB(ub_postion)

func after_ub_effect() -> void:
	var amount : int = - int(skill.side_dmg * stats.magic * (1 + 0.3 * num_enemy) / 100)
	var healMachine = DamageMachine.new()
	healMachine.setter(owner, amount, 4, false)
	for each in members:
		healMachine.heal_received(each)
