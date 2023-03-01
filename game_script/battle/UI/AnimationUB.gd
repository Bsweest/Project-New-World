extends Node2D

class_name AnimationUB

signal finish_ub(is_party, pos)

var labelInstance = preload("res://components/UI/UILabelUB.tscn")

onready var _aniSprite : AnimatedSprite = $AnimatedSprite
onready var _area : Sprite = $D_Area
onready var _vbox : VBoxContainer = $VBoxContainer

var pos : int
var is_party := false
var skill_name : String = ""

var arrLabel := []
var current := 0
var num_add := 0
var timer: Timer = Timer.new()

func _ready():
	var arr = skill_name.split(" ", true)
	num_add = arr.size()
	for each in arr:
		var label = labelInstance.instance()
		label._txt = each
		arrLabel.append(label)
	_aniSprite.playing = false
	_vbox.rect_scale = Vector2(-1, 1)
	visible = false
	timer.one_shot = true
	timer.wait_time = 0.2
	timer.connect("timeout", self, "add_skill_name")
	add_child(timer)

func start_ub_ani(_position: Vector2, ub_hitbox_position: int) -> void:
	position = _position
	visible = true
	_aniSprite.frame = 0
	_aniSprite.playing = true
	add_skill_name()


func add_skill_name() -> void:
	if current < num_add:
		_vbox.add_child(arrLabel[current])
		arrLabel[current].appear_on_screen()
		current += 1
		if current != num_add:
			timer.start()
		else:
			current = 0
	

func _on_AnimatedSprite_animation_finished() -> void:
	visible = false
	for each in _vbox.get_children():
		_vbox.remove_child(each)
	emit_signal("finish_ub", pos)
