extends Node

var dialog = preload("res://dialog/story 1/dialog_story1_1.tres")

onready var btn_area : Button = $"CityHall/TopControl/ArenaButton"
onready var btn_guild : Button = $"CityHall/TopControl/GuildButton"
onready var btn_shop : Button = $"CityHall/TopControl/ShopButton"
onready var tutorial : TutorialCanvas = $TutorialCanvas

func _ready():
	DialogueManager.show_dialogue(\
		"story_begin", \
		dialog
	)

func click_guild_house() -> void:
	tutorial.point_to_this(Vector2(1670, 365))
	tutorial.set_text_guide("Đi đến Bang hội")
	yield(btn_guild, "pressed")
