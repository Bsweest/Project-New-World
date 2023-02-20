extends Node2D

class_name UISelectArea

signal choose_done(_position)

onready var _area : Sprite = $D_Area

var pos : int = -1
var mouse_pos : Vector2

func _ready():
	_area.visible = false

func _process(_delta) -> void:
	if !_area.visible:
		return
	mouse_pos = get_global_mouse_position()
	_area.position.x = mouse_pos.x / 2

func _input(event: InputEvent):
	if !_area.visible || pos == -1:
		return
	if event.is_action_pressed("left_click"):
		emit_signal("choose_done", pos, mouse_pos.x / 2)
		disable_choose_area()
		return
	if event.is_action_pressed("right_click"):
		disable_choose_area()

func enable_choose_area(_pos: int) -> void:
	pos = _pos
	_area.visible = true

func disable_choose_area() -> void:
	_area.visible = false
	pos = -1

func _on_user_Select_area(pos):
	enable_choose_area(pos)

