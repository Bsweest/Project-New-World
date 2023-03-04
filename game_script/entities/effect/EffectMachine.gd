extends Node

class_name EffectMachine

enum EffectType { STATUS, STAT, DOT }
enum StatusName  { IMMUNE, CURSE, SILENT, STUN, FREEZE, SHOCK }

var stats : CharacterStats
var _body
var is_party : bool
var pos : int

var affected_status := []

func setter(body, isParty: bool, index: int, eStat: CharacterStats) -> void:
    _body = body
    is_party = isParty
    pos = index
    stats = eStat

func reset_effect_machine() -> void:
    for each in get_children():
        each.queue_free()

func add_effect_to_Body(effect: Effect) -> void:
    if effect.type == 0:
        effect.connect("status_apply", _body, "_on_CC_status_applied")
    elif effect.type == 1:
        effect.connect("effect_apply", stats, "_modify_stat")
    add_child(effect)
    if is_party:
        Utils.status_effect_applied(pos, effect.icon)

func add_affected_status_to_Arr(name: int, is_increase: bool) -> void:
    if is_increase:
        affected_status.append(name)
    else:
        affected_status.erase(name)

func remove_bad_effect(type: int, name: int) -> void:
    if name == -1:
        for each in get_children():
            if each.cleanable:
                each.queue_free()
    else:
        if type == EffectType.STATUS:
            for each in get_children():
                if each.status_name == name && each.cleanable:
                    each.queue_free()
