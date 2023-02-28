extends Node2D

class_name State

enum { IDLE, RUNNING, KNOCKBACKED, LOAD_AA, SHOOT, DEATH, STUN }

var s_name : int
var change_state : FuncRef
var ani_player : AnimationPlayer
var _body

var velocity : Vector2 = Vector2.ZERO

func movement_control() -> void:
	_body.move_and_slide(velocity)


func _physics_process(_delta) -> void:
	movement_control()


func setup(_change_state: FuncRef, _ani_player: AnimationPlayer, body) -> void:
	self.change_state = _change_state
	self.ani_player = _ani_player
	self._body = body
