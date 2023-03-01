extends CanvasLayer

onready var ani_player : AnimationPlayer = $AnimationPlayer
onready var quest_guide : Label = $NinePatchRect/QuestGuide
onready var pointer : Control = $Pointer
onready var click_guide : Label = $Pointer/Bar/ClickGuide

var _txt_guide : String = "" setget set_text_guide

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_text_guide(new_guide: String) -> void:
	_txt_guide = new_guide
	quest_guide.text = _txt_guide
	ani_player.play("new_quest")

func point_to_this(to_position: Vector2, new_guide: String) -> void:
	get_tree().paused = true
	pointer.visible = true
	pointer.set_position(to_position)
	click_guide.text = new_guide
	ani_player.play("point_to")


