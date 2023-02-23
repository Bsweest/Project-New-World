extends Node

class_name EffectMachine

enum EffectType { STATUS, EFFECT, DOT }

var stats : CharacterStats
var skill : CharacterSkill

func setter(eStat: CharacterStats, eSkill: CharacterSkill) -> void:
    stats = eStat
    skill = eSkill

func add_effect(apllier, time: float, type: int, name: int, flat: int, percent: int) -> void:
    var effect = Effect.new()
    effect.set_default(apllier, time)
    if type == EffectType.STATUS:
        effect.set_status(name)
    elif type == EffectType.EFFECT:
        effect.set_stat(name, flat, percent)
        effect.connect("effect_aplly", stats, "_modify_stat")
    elif type == EffectType.DOT:
        effect.set_dot(name, flat, percent)
    add_child(effect)