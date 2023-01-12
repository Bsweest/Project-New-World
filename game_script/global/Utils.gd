extends Node

var scaling : int = 1

func isCrit(crit_c: float) -> bool:
	var thresh = randf()
	if thresh > 1 - crit_c:
		return true
	return false
