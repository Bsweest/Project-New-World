extends Node2D

class_name UISelectArea

signal choose_done(_position)

onready var _area : Sprite = $D_Area

var pos : int = -1
var mouse_pos : int
var view_port : Viewport
var scale_factor

func _ready():
	_area.visible = false

func setup_viewport(_view) -> void:
	view_port = _view

func _process(_delta) -> void:
	if !_area.visible:
		return
	mouse_pos = get_global_mouse_position().x / scale_factor * 640
	_area.position.x = mouse_pos

func _input(event: InputEvent):
	if !_area.visible || pos == -1:
		return
	if event.is_action_pressed("left_click"):
		emit_signal("choose_done", pos, mouse_pos)
		disable_choose_area()
		return
	if event.is_action_pressed("right_click"):
		disable_choose_area()

func enable_choose_area(_pos: int) -> void:
	pos = _pos
	_area.visible = true
	var viewport_base_size = (
		get_viewport().get_size_override() if get_viewport().get_size_override() > Vector2(0, 0)
		else get_viewport().size
	)
	scale_factor = (OS.window_size / viewport_base_size).x

func disable_choose_area() -> void:
	_area.visible = false
	pos = -1

func _on_user_Select_area(_pos):

	enable_choose_area(_pos)

