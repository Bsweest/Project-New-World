extends Node

class_name EffectMachine

var stats : CharacterStats
var _body
var is_party : bool
var pos : int

func setter(body, isParty: bool, index: int, eStat: CharacterStats) -> void:
    _body = body
    is_party = isParty
    pos = index
    stats = eStat

func add_effect_to_Body(effect: Effect) -> void:
    if effect.type == 0:
        effect.connect("status_apply", _body, "_on_CC_status_applied")
    elif effect.type == 1:
        effect.connect("effect_apply", stats, "_modify_stat")
    add_child(effect)
    if is_party:
        Utils.status_effect_applied(pos, effect.icon)