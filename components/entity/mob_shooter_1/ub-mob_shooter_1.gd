extends NodeUBShoot

const WAIT_TIME = 12
var running_tick = 0
var num_shoot = 3
var have_shoot = 3

func _init():
	_texture = "res://assets/projectile/spark.png"

func activeUB(_ub_postion: int) -> void:
	.activeUB(_ub_postion)
	have_shoot = 1

func _physics_process(_delta) -> void:
	if have_shoot == num_shoot:
		return
	running_tick += 1
	if running_tick == WAIT_TIME:
		shoot_ub()
		have_shoot += 1
		running_tick = 0
	
