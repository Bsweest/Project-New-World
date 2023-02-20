extends CharacterTransform

const DURATION_TIME := 30
var running_time := 30
var openHitbox := false

func init_transform() -> void:
	pass

func activeTransform() -> void:
	var damage = DamageMachine.new()
	damage.setter(owner, int(skill.side_dmg * stats.magic / 100), 1, false)
	_hitbox.setter(damage, true)
	.activeTransform()

func _process(_delta) -> void:
	if not is_active:
		return
	#? toggle hit box
	running_time -= 1
	if running_time > 0:
		return
	if openHitbox:
		_hitbox.enable_collision()
		openHitbox = false
	else:
		_hitbox.disable_collision()
		openHitbox = true
	running_time = DURATION_TIME
