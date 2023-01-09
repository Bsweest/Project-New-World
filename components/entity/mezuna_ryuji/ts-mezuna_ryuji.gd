extends CharacterTransform

func init_transform() -> void:
	_hitbox.dmg = int(skill.side_dmg * stats.magic / 100)
	_hitbox.type = 1
	_hitbox.is_crit = false
