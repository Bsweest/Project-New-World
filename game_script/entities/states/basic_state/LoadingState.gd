extends State

class_name LoadingState

func _ready():
    ani_player.play("loading")
    velocity.x = 0