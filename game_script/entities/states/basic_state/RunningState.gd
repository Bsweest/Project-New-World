extends State

class_name RunningState

func _ready():
    pass
    
func movement_control() -> void:
    if not _body.can_range_move:
        change_state.call_func(LOAD_AA)

    velocity.x = _body.get_movement()
    _body.move_and_slide(velocity)