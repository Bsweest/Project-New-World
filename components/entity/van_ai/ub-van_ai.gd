extends NodeUBArea

var num_enemy := 0
var healMachine = DamageMachine.new()

func _ready():
	healMachine.setter(owner, 0, 4, false)

func activeUB(ub_postion: int) -> void:
	num_enemy = 0
	.activeUB(ub_postion)

func _on_HitBox_body_entered(body):
	if body.get_class() == "Entity":
		num_enemy += 1

func after_ub_effect() -> void:
	var amount : int = - int(skill.side_dmg * stats.magic * (1 + 0.3 * num_enemy) / 100)
	healMachine.modify(amount)
	for each in members:
		healMachine.heal_received(each)
