extends CanvasLayer

class_name UBLayer

onready var animations = $Animations

var arrAni : Array

func setter(arr: Array) -> void:
	arrAni = arr
	for each in arr:
		each.connect("finish_ub", get_parent(), "_on_UB_animation_finished")
		animations.add_child(each)

func remove_ani() -> void:
	for n in animations.get_children():
		animations.remove_child(n)

func run_ub_ani(pos: int, _position: Vector2, ub_hitbox_position: int = -1) -> void:
	if arrAni[pos] == null:
		return
	arrAni[pos].start_ub_ani(_position, ub_hitbox_position)
	get_tree().paused = true
