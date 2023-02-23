extends Resource

class_name BaseSkill

enum DamameType { PHYSIC, MAGIC, TRUE, PIERCE, HEAL }
enum MultipilerType { SAME, PHYSIC, MAGIC, HP }
enum SideEffect { NONE, BUFF, TRANSFORM }

export var skill_name : String = 'skill_name'
export var skill_description : String = ''

export var base_dmg : int = 0
export var side_dmg : int = 0
export var need_choose : bool = false

export (DamameType) var type
export (MultipilerType) var multipiler_type := 0
export (SideEffect) var side_effect 
