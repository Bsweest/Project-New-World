extends Node

onready var _container : ViewportContainer = $ViewportContainer
onready var _viewport : Viewport = $ViewportContainer/Viewport
onready var area_choose : UISelectArea = $ViewportContainer/Viewport/BattleManager/SelectArea
onready var screen_res = get_viewport().size

var scaling = Vector2.ZERO

func _ready():
	randomize()
	scaling = screen_res / _viewport.size
	_container.rect_scale = scaling
	area_choose.setup_viewport(_viewport)
