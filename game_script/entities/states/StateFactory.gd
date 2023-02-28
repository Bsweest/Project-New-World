class_name StateFactory

enum { IDLE, RUNNING, KNOCKBACKED, LOAD_AA, SHOOT, DEATH, CC_ED }

var states

func _init():
    states = {
        IDLE: IdleState,
        RUNNING: RunningState,
        KNOCKBACKED: KnockBackState,
        LOAD_AA: LoadingState,
        SHOOT: ShootState,
        DEATH: DeathState,
        CC_ED: CrowdControledState,
    }

func get_state(state_name):
    if states.has(state_name):
        return states.get(state_name)