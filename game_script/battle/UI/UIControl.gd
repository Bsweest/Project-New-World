extends CanvasLayer

class_name UIControl

onready var btn_pause : TextureButton = $TextureRect/PauseButton
onready var _control : TextureRect 	= $Dialog
onready var _aniPlayer : AnimationPlayer = $Dialog/EndGame/AnimationPlayer
#? END GAME control
onready var _endgame : Control = $Dialog/EndGame
onready var _title_win : RichTextLabel = $Dialog/EndGame/Title/Win
onready var _title_lose : RichTextLabel = $Dialog/EndGame/Title/Lose
onready var _exp_value : Label = $Dialog/EndGame/TextureRect/EXPvalue
onready var btn_next : TextureButton = $Dialog/EndGame/PlayRect/ButtonNext
#? PAUSED GAME control
onready var pause_screen : Control = $Dialog/PausedScreen
onready var btn_audio : TextureButton = $Dialog/PausedScreen/TextureRect/HBoxContainer/TextureRect/ButtonAudio
onready var btn_exit : TextureButton = $Dialog/PausedScreen/TextureRect/HBoxContainer/TextureRect2/ButtonExit
onready var btn_resume : TextureButton = $Dialog/PausedScreen/PlayRect/ButtonPlay

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
	btn_pause.get_parent().visible = false
	pause_screen.visible = false
	_endgame.visible = true
	_title_win.visible = is_winning
	_title_lose.visible = !is_winning
	get_tree().paused = true
	_control.visible = false
	_aniPlayer.play("end_game")

#// Manage Scene Changing
func _on_ButtonExit_pressed() -> void:
	pass # Replace with function body.

func _on_ButtonNext_pressed() -> void:
	pass # Replace with function body.

#// Manage Function
func _on_ButtonAudio_pressed() -> void:
	pass # Replace with function body.

func change_tree_state() -> void:
	_control.visible = not _control.visible
	get_tree().paused = not get_tree().paused

func change_tree_state_bool(boolean: bool) -> void:
	_control.visible = boolean
	get_tree().paused = boolean
