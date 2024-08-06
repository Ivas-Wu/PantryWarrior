class_name skill_handler
extends Node

signal initialized

#
var unlocked_abilities : Array[int]
var skill_tree_instance : skill_tree
# for seraching
var default_ability_pool_1 : Array[int]
var default_ability_pool_2 : Array[int]
var default_ability_pool_3 : Array[int]
var default_ability_pool_4 : Array[int]
var postrec_ability_pool_1 : Array[int]
var postrec_ability_pool_2 : Array[int]
var postrec_ability_pool_3 : Array[int]
var postrec_ability_pool_4 : Array[int]

enum SkillVariables {
	AGILITY,
	ATTACK,
	KNOCKBACK_DONE,
	STUN,
	HP,
	DEFENSE,
	KNOCKBACK_TAKEN,
	BIG_ATTACK,
	SPECIAL_ATTACK,
	GROUND_ATTACK,
	DASH_ATTACK,
	PLUMMET,
	PLUMMET_PLUS,
	SHIELD,
	ROLL,
	DASH,
	WALL_JUMP,
	TRIPLE_JUMP,
	CHARGED_JUMP,
	GOGGLES,
	HEALTH_REGEN,
	LIFESTEAL,
	BONUS_EXP,
	BONUS_HEALING
}

# Define your variables in a dictionary with initial values
var skill_variables = {
	SkillVariables.AGILITY: 0.0,
	SkillVariables.ATTACK: 0.0,
	SkillVariables.KNOCKBACK_DONE: 0.0,
	SkillVariables.STUN: 0.0,
	SkillVariables.HP: 0.0,
	SkillVariables.DEFENSE: 0.0,
	SkillVariables.KNOCKBACK_TAKEN: 0.0,
	
	SkillVariables.BIG_ATTACK: false,
	SkillVariables.SPECIAL_ATTACK: false,
	SkillVariables.GROUND_ATTACK: false,
	SkillVariables.DASH_ATTACK: false,
	SkillVariables.PLUMMET: false,
	SkillVariables.PLUMMET_PLUS: false,
	SkillVariables.SHIELD: false,
	
	SkillVariables.ROLL: false,
	SkillVariables.DASH: false,
	SkillVariables.WALL_JUMP: false,
	SkillVariables.TRIPLE_JUMP: false,
	SkillVariables.CHARGED_JUMP: false,
	
	SkillVariables.GOGGLES: false,
	SkillVariables.HEALTH_REGEN: 0.0,
	SkillVariables.LIFESTEAL: 0.0,
	SkillVariables.BONUS_EXP: 0.0,
	SkillVariables.BONUS_HEALING: 0.0
}

var agility : float
var attack : float
var knockback_done : float
var stun : float
var hp: float
var defense : float
var knockback_taken : float

# combat
var big_attack : bool
var special_attack : bool
var ground_attack : bool
var dash_attack : bool
var plummet : bool
var plummet_plus : bool
var shield : bool

#movement
var roll : bool
var dash : bool
var wall_jump : bool
var triple_jump : bool
var charged_jump : bool

# utility
var goggles : bool
var health_regen : float
var lifesteal : float
var bonus_exp : float
var bonus_healing : float

# fury
#todo

func _ready():
	set_physics_process(false)
	skill_tree_instance = skill_tree.new()
	initialized.emit()

func load_abilities(_data : Array[int]):
	unlocked_abilities = _data
	# update ability pools TODO
	for d in _data:
		add_ability(d)

func add_ability(index : int):
	var skill = skill_tree_instance.skills_list[index]
	var skill_key = SkillVariables[skill[3]]

	if skill_key != null:
		if typeof(skill_variables[skill_key]) == TYPE_BOOL:
			skill_variables[skill_key] = true
		else:
			skill_variables[skill_key] = skill[4]

func get_skills(count : int): #TODO
	var res = []
	for c in count:
		res.append(skill_tree_instance.skills_list[c])
	return res
		
