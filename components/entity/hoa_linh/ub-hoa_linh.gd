extends NodeUB


func create_skill_effect() -> Effect:
	var effect = Effect.new()
	effect.set_default(character, 4.0)
	effect.set_stat(0, 0, 30)
	return effect

func activeUB(_var) -> void:
	for each in members:
		if not each.check_death_status():
			var addEff : Effect = create_skill_effect()
			each.get_added_effect(addEff)
