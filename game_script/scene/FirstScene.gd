extends Control

var dialog = preload("res://dialog/first_scene/dialog_first_scene.tres")

onready var _aniPlayer : AnimationPlayer = $AnimationPlayer
onready var _sprite : Sprite = $Sprite

func _ready():
	DialogueManager.show_dialogue(\
		"first_scene_of_game", \
		dialog
	)

func black_out() -> void:
	_aniPlayer.play("black_out")

func go_light() -> void:
	_aniPlayer.play("go_light")
	yield(_aniPlayer, "animation_finished")

func wagon() -> void:
	_aniPlayer.play("wagon")
	yield(_aniPlayer, "animation_finished")
