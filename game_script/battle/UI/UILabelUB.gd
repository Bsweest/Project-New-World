extends Control

onready var ani_player : AnimationPlayer = $AnimationPlayer
onready var label : Label = $Control/Label

var _txt : String = ""

func _ready():
	label.text = _txt

func appear_on_screen() -> void:
	ani_player.play("appear")
