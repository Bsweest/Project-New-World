extends State

class_name IdleState

func _ready():
    velocity.x = 0
    _body.out_of_game_loop()