extends State

class_name StunState

func _ready():
    ani_player.play("idle")
    velocity.x = 0

func set_status_name(_status_name: int) -> void:
    pass
    
