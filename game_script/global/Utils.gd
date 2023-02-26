extends Node

signal buff_changed(pos, icon)

var scaling : int = 1

func status_effect_applied(pos: int, icon: StatusEffectIcon) -> void:
	emit_signal("buff_changed", pos, icon)
