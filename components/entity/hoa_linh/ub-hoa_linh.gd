extends NodeUB

enum StatusName { IMMUNE, CURSE, SILENT, STUN, FREEZE, SHOCK }

func create_skill_effect(receiver) -> void:
	var effect = Effect.new()
	var effect2 = Effect.new()
	effect.set_default(character, 4.0)
	effect.set_stat(0, 0, 30)
	effect2.set_default(character, 1.0)
	effect2.set_status(0)
	receiver.get_added_effect(effect)
	receiver.get_added_effect(effect2)

func activeUB(_var) -> void:
	for each in members:
		if not each.check_death_status():
			create_skill_effect(each)
			each.effectMachine.remove_bad_effect(0, StatusName.FREEZE)
			
