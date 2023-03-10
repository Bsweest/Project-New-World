extends Node

var dialog = preload("res://dialog/story 1/dialog_story1_1.tres")
var alley = preload("res://assets/mics/secondary_canvas/TownRoad_DayTime.png")

onready var tutorial : TutorialCanvas = $TutorialCanvas
onready var btn_recept : Button = $TextureRect/ReceptButton
onready var btn_out : TextureButton = $TextureRect/BtnOut

func _ready():
	DialogueManager.show_dialogue(\
		"first_in_guild", \
		dialog
	)

func click_on_recept() -> void:
	tutorial.set_text_guide("Hỏi chuyện với Lễ tân")
	yield(btn_recept, "pressed")

func find_another_way() -> void:
	tutorial.set_text_guide("Tìm cách khác")
	yield(btn_out, "pressed")
	tutorial.add_new_secondary_scene(alley)
