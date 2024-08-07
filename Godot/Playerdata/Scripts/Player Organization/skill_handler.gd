class_name skill_handler
extends Node

signal initialized

#
var unlocked_abilities : Dictionary
var skill_tree_instance : skill_tree
# for seraching
var basic_ability_pool_t1 : Array[int]
var basic_ability_pool_t2 : Array[int]
var basic_ability_pool_t3 : Array[int]
var basic_ability_pool_t4 : Array[int]
var postrec_ability_pool_t1 : Array[int]
var postrec_ability_pool_t2 : Array[int]
var postrec_ability_pool_t3 : Array[int]
var postrec_ability_pool_t4 : Array[int]

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

func _ready():
	set_physics_process(false)
	skill_tree_instance = skill_tree.new()
	load_abilities(load("res://Playerdata/Resource/PlayerSkills.tres").ability_index_list)
	initialized.emit()

func reset_card_pool():
	basic_ability_pool_t1 = []
	basic_ability_pool_t2 = []
	basic_ability_pool_t3 = []
	basic_ability_pool_t4 = []
	postrec_ability_pool_t1 = []
	postrec_ability_pool_t2 = []
	postrec_ability_pool_t3 = []
	postrec_ability_pool_t4 = []
	
func load_abilities(_data : Array):
	# update ability pools TODO
	for d in _data:
		add_ability(d)
	populate_card_pool()

func add_ability(index: int, reprocess: bool = false):
	var skill = skill_tree_instance.skills_list[index]
	var skill_key = SkillVariables[skill[3]]

	if skill_key != null:
		unlocked_abilities[index] = 1 #add to dictionary for fast lookup times, value is unused atm
		if typeof(skill_variables[skill_key]) == TYPE_BOOL:
			skill_variables[skill_key] = true
		else:
			skill_variables[skill_key] = skill[4]
		if reprocess:
			populate_card_pool()

func populate_card_pool():
	reset_card_pool()
	for s in skill_tree_instance.skills_list:
		var tier: int = s[5]
		var prereq: Array = s[6]
		if unlocked_abilities.has(s[0]):
			continue
		elif prereq.is_empty():
			match(tier):
				1:
					basic_ability_pool_t1.append(s[0])
				2:
					basic_ability_pool_t2.append(s[0])
				3:
					basic_ability_pool_t3.append(s[0])
				4:
					basic_ability_pool_t4.append(s[0])
		elif validate_prereq(prereq):
			match(tier):
				1: 
					postrec_ability_pool_t1.append(s[0])
				2: 
					postrec_ability_pool_t2.append(s[0])
				3: 
					postrec_ability_pool_t3.append(s[0])
				4: 
					postrec_ability_pool_t4.append(s[0])

func validate_prereq(prereq: Array[int]):
	for pr in prereq:
		if !unlocked_abilities.has(pr): 
			return false
	return true

func get_skills(count: int, level: int = 0):
	if level == 0: return []
	var res = []
	var level_percent = skill_tree_instance.level_percentage[level]
	var pool: Array
	
	for c in count:
		#TODO randomize the tier and add percentage for upgraded skills
		#TODO prevent duplicates
		pool = basic_ability_pool_t1.duplicate()
		if !pool.is_empty():
			var rand = randi() % pool.size()
			res.append(skill_tree_instance.skills_list[pool[rand]])
	return res
		
