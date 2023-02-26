extends CanvasLayer

class_name UIControl

onready var btn_pause : TextureButton = $PauseButton
onready var menu_board : TextureRect = $MenuBoard
onready var aniPlayer : AnimationPlayer = $AnimationPlayer
#? END GAME control
onready var endgame_menu : Control = $MenuBoard/EndGameMenu
onready var title_win : TextureRect = $MenuBoard/EndGameMenu/TopBar/TitleWin
onready var title_lose : TextureRect = $MenuBoard/EndGameMenu/TopBar/TitleLose
onready var num_exp : Label = $MenuBoard/EndGameMenu/NumExp
onready var items_earn_grid : GridContainer = $MenuBoard/EndGameMenu/ScrollContainer/GridItemsEarn
# onready var btn_next : TextureButton = $Dialog/EndGame/PlayRect/ButtonNext
#? PAUSED GAME control
onready var pause_menu : Control = $MenuBoard/PauseMenu
onready var btn_resume : TextureButton = $MenuBoard/PauseMenu/BtnPlay
onready var btn_audio : TextureButton = $MenuBoard/PauseMenu/BtnMusic
onready var btn_exit : TextureButton = $MenuBoard/PauseMenu/BtnOut

var is_end := false

#// Manage Game Tree state
func _on_PauseButton_pressed() -> void:
	change_tree_state()

func _on_ButtonPlay_pressed() -> void:
	change_tree_state_bool(false)

func _on_End_game(is_winning: bool) -> void:
	is_end = true
	title_win.visible = is_winning
	title_lose.visible = !is_winning
	get_tree().paused = true
	aniPlayer.play("end_game")

#// Manage Scene Changing
func _on_BtnOut_pressed():
	pass # Replace with function body.


#// Manage Function
func _on_BtnMusic_pressed():
	pass # Replace with function body.

func change_tree_state() -> void:
	menu_board.visible = not menu_board.visible
	get_tree().paused = not get_tree().paused

func change_tree_state_bool(boolean: bool) -> void:
	menu_board.visible = boolean
	get_tree().paused = boolean
