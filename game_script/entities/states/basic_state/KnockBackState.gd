extends State

class_name KnockBackState

var max_duration = 10 # Can change duration for some skill
var knockbacked_duration : int = 0

func _ready():
    knockbacked_duration = max_duration
    velocity.x = _body.party_direction * -500

func movement_control() -> void:
    _body.move_and_slide(velocity)
    knockbacked_duration -= 1
    if knockbacked_duration == 0:
        if _body.get_stun_status():
            change_state.call_func(STUN)
        else:
            change_state.call_func(RUNNING)
