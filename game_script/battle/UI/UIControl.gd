extends CanvasLayer

class_name UIControl

onready var btn_pause : TextureButton = $TextureRect/PauseButton
onready var _control : Control	= $Control
#? END GAME control
onready var _endgame : Control = $Control/Dialog/EndGame
onready var _title_win : TextureRect = $Control/Dialog/EndGame/Title/Win
onready var _title_lose : TextureRect = $Control/Dialog/EndGame/Title/Lose
onready var _exp_value : Label = $Control/Dialog/EndGame/TextureRect/EXPvalue
onready var btn_next : TextureButton = $Control/Dialog/EndGame/PlayRect/ButtonNext
#? PAUSED GAME control
onready var pause_screen : VBoxContainer = $Control/Dialog/PausedScreen
onready var btn_audio : TextureButton = $Control/Dialog/PausedScreen/TextureRect/HBoxContainer/TextureRect/ButtonAudio
onready var btn_exit : TextureButton = $Control/Dialog/PausedScreen/TextureRect/HBoxContainer/TextureRect2/ButtonExit
onready var btn_resume : TextureButton = $Control/Dialog/PausedScreen/PlayRect/ButtonPlay

var is_end := false

func _ready() -> void:
	_control.visible = false
	pause_screen.visible = true
	_endgame.visible = false

func _input(event: InputEvent) -> void:
	if is_end:
		return
	if event.is_action_pressed("ui_cancel"):
		change_tree_state()

#// Manage Game Tree state
func _on_PauseButton_pressed() -> void:
	change_tree_state()

func _on_ButtonPlay_pressed() -> void:
	change_tree_state_bool(false)

func _on_End_game(is_winning: bool) -> void:
	is_end = true
	pause_screen.visible = false
	btn_pause.visible = false
	_endgame.visible = true
	_title_win.visible = is_winning
	_title_lose.visible = !is_winning
	change_tree_state_bool(true)

#// Manage Scene Changing
func _on_ButtonExit_pressed() -> void:
	pass # Replace with function body.

func _on_ButtonNext_pressed() -> void:
	pass # Replace with function body.

#// Manage Function
func _on_ButtonAudio_pressed() -> void:
	pass # Replace with function body.

func change_tree_state() -> void:
	_control.visible = !_control.visible
	get_tree().paused = !get_tree().paused

func change_tree_state_bool(boolean: bool) -> void:
	_control.visible = boolean
	get_tree().paused = boolean
