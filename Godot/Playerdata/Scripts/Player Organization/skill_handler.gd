class_name skill_handler
extends Node

signal initialized
signal reprocess_data

#
var unlocked_abilities : Dictionary
var skill_tree_instance : skill_tree
# for seraching
var basic_ability_pools : Array[Array]
var postrec_ability_pools : Array[Array]
var max_tier: int = 4
var max_level: int = 6 #TODO 10 later

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
	TRUE_SIGHT,
	HEALTH_REGEN,
	LIFESTEAL,
	BONUS_EXP,
	BONUS_HEALING,
	BERSERKER, 
	SUSANOO, 
	DIVINE_TAKEOVER, 
	PHASING, 
	STAT_OVERLOAD, 
	FEATHERWEIGHT, 
	LUCKY_DROPS, 
	LAST_STAND, 
	CROCKPOT, 
	BLESSED_ARMOR, 
	FOF, 
	SCHOLAR,
	CONSECUTIVE_STRIKES,
	CONSECUTIVE_STRIKES_PLUS,
	INVULNERABILITY,
	SECOND_WIND,
}

# Define your variables in a dictionary with initial values
# Default is always false or 0.0
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
	
	SkillVariables.SHIELD: false, #TODO
	SkillVariables.ROLL: false,
	SkillVariables.DASH: false, #TODO
	SkillVariables.WALL_JUMP: false, 
	SkillVariables.TRIPLE_JUMP: false,
	SkillVariables.CHARGED_JUMP: false,
	
	SkillVariables.TRUE_SIGHT: false,#TODO
	SkillVariables.HEALTH_REGEN: 0.0,#TODO from here down
	SkillVariables.LIFESTEAL: 0.0,
	SkillVariables.BONUS_EXP: 0.0,
	SkillVariables.BONUS_HEALING: 0.0,
	
	SkillVariables.BERSERKER: false,
	SkillVariables.SUSANOO: false,
	SkillVariables.DIVINE_TAKEOVER: false,
	SkillVariables.PHASING: false,
	SkillVariables.STAT_OVERLOAD: false,
	SkillVariables.FEATHERWEIGHT: false,
	SkillVariables.LUCKY_DROPS: false,
	SkillVariables.LAST_STAND: false,
	SkillVariables.CROCKPOT: false,
	SkillVariables.BLESSED_ARMOR: false,
	SkillVariables.FOF: false,
	SkillVariables.SCHOLAR: false,
	SkillVariables.CONSECUTIVE_STRIKES: 0,
	SkillVariables.CONSECUTIVE_STRIKES_PLUS: 0,
	SkillVariables.INVULNERABILITY: 0,
	SkillVariables.SECOND_WIND: 0
}

func _ready():
	set_physics_process(false)
	skill_tree_instance = skill_tree.new()
	load_abilities(load("res://Playerdata/Resource/PlayerSkills.tres").ability_index_list)
	initialized.emit()

func reset_card_pool():
	basic_ability_pools = []
	postrec_ability_pools = []
	for i in max_tier:
		basic_ability_pools.append([])
		postrec_ability_pools.append([])
	
func load_abilities(_data : Array):
	# update ability pools TODO
	for d in _data:
		add_ability(d)
	populate_card_pool()

func add_ability(index: int, reprocess: bool = false):
	var skill = skill_tree_instance.skills_list[index]
	var skill_key = SkillVariables[skill[4]]

	if skill_key != null:
		unlocked_abilities[index] = 1 #add to dictionary for fast lookup times, value is unused atm
		if typeof(skill_variables[skill_key]) == TYPE_BOOL:
			skill_variables[skill_key] = true
		else:
			skill_variables[skill_key] = skill[5]
		if reprocess:
			populate_card_pool()
			reprocess_data.emit()

func populate_card_pool():
	reset_card_pool()
	for s in skill_tree_instance.skills_list:
		var tier: int = s[1]
		var prereq: Array = s[6]
		if unlocked_abilities.has(s[0]):
			continue
		elif prereq.is_empty():
			basic_ability_pools[tier-1].append(s[0])
		elif validate_prereq(prereq):
			postrec_ability_pools[tier-1].append(s[0])

func validate_prereq(prereq: Array):
	for pr in prereq:
		if !unlocked_abilities.has(pr): 
			return false
	return true

func get_skills(count: int, level: int = 0):
	if level == 0: return []
	var res = []
	var level_percent = skill_tree_instance.level_percentage[level]
	var pool: Array = []
	var tmp_basic_pool = basic_ability_pools.duplicate(true)
	var tmp_postrec_pool = postrec_ability_pools.duplicate(true)
	
	for c in count:
		var rand_tier = randf()
		var temp_value = 0
		for i in range(1, max_tier + 1):
			temp_value += level_percent[i]
			if (rand_tier <= temp_value):
				if randf() <= level_percent[max_tier + 1] and !tmp_postrec_pool[i - 1].is_empty():
					pool = tmp_postrec_pool[i - 1]
				else:
					pool = tmp_basic_pool[i - 1]
					pool.append_array(tmp_postrec_pool[i - 1])
				break
			
		if !pool.is_empty():
			var rand = randi() % pool.size()
			res.append(skill_tree_instance.skills_list[pool[rand]])
			pool.remove_at(rand)
	return res
