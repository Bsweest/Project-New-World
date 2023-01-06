extends Node2D

class_name LayerUB

signal finish()

onready var _canvas : CanvasLayer = $CanvasLayer as CanvasLayer
onready var _node : Node2D = $CanvasLayer/Node2D as Node2D
onready var _aniSprite : AnimatedSprite = $CanvasLayer/Node2D/AnimatedSprite as AnimatedSprite
onready var _hitbox : HitBox = $HitBox as HitBox

var timer = Timer.new()
var is_party : bool
var skil_dmg : int
var s_name : String
var type : int
var first_set := false

func init(skill: CharacterSkill, is_p: bool) -> void:
	is_party = is_p
	skil_dmg = skill.dmg
	s_name = skill.skill_name
	type = skill.type

func _ready() -> void:
	pause_mode = Node.PAUSE_MODE_PROCESS
	visible = false
	_canvas.visible = false
	timer.connect("timeout", self, "do_this")
	timer.wait_time = 0.1
	timer.one_shot = true
	add_child(timer)

	if is_party:
		_node.scale = Vector2(-1, 1)
	_hitbox.dmg = skil_dmg
	_hitbox.is_crit = false
	_hitbox.type = type
	_hitbox.init(is_party)
	_hitbox.disable_collision()
	_aniSprite.connect("animation_finished", self, "_on_UB_animation_finished")

func runAnimation(pos: Vector2) -> void:
	if !first_set:
		first_set = true
		_hitbox.scale = Vector2(1, 1)
	visible = true
	_node.position = pos
	_canvas.visible = true
	_aniSprite.frame = 0
	_aniSprite.playing = true

func _on_UB_animation_finished() -> void:
	get_tree().paused = false
	_hitbox.enable_collision()
	visible = false
	_canvas.visible = false
	_aniSprite.playing = false
	emit_signal("finish")
	timer.start()

func do_this() -> void:
	_hitbox.disable_collision()
