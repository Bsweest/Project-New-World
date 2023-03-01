extends CanvasLayer

class_name UBLayer

onready var members = $Members

func setter(is_member: bool, arr: Array) -> void:
	for i in len(arr):
		var path = "res://components/entity/" + arr[i]["name"] + "/ub_ani.tscn"
		var directory = Directory.new()
		if directory.file_exists(path):
			var baseSkill : BaseSkill = load("res://game_script/skills/resources/" + arr[i]["name"] + ".tres")
			var ani : AnimationUB = load(path).instance()
			if is_member: 
				ani.scale = Vector2(-1, 1)
			ani.pos = i
			ani.is_party = is_member
			ani.skill_name = baseSkill.skill_name
			ani.connect("finish_ub", get_parent(), "_on_UB_animation_finished")
			members.add_child(ani)

func run_ub_ani(pos: int, _position: Vector2, ub_hitbox_position: int = -1) -> void:
	members.get_child(pos).start_ub_ani(_position, ub_hitbox_position)
	get_tree().paused = true
