class_name skill_tree
extends Resource

#enum Stats {
	#AGILITY = 0,
	#ATTACK = 1,
	#KNOCKBACK_DONE = 2,
	#STUN = 3,
	#HP = 4,
	#DEFENSE = 5,
	#KNOCKBACK_TAKEN = 6,
	#FLAG = 7
#}

var default_strings = {
	"UNLOCK" : "Unlock the ability to %s.",
	"MULTIPLIER" : "Increase %s by %d%%.",
	"ATTACK" : "New attack: %s.",
	"ATTACK_UPGRADE" : "Attack upgrade: %s.",
	"ABILITY" : "New ability: %s %s.",
	"ABILITY_UPGRADE" : "Ability upgrade: %s %s.",
}

# index, icon, description, ENUM, modifier, tier, prereq[]
var skills_list = [
	[0, 1, get_icon_path("Agility.png"), ["Quickness I", multipiler_string("agility", 10)], "AGILITY", 0.1, []],
	[1, 1, get_icon_path("Damage.png"), ["Attack I", multipiler_string("damage", 15)], "ATTACK", 0.15, []],
	[2, 1, get_icon_path("Damage.png"), ["Strength I", multipiler_string("knockback dealt", 20)], "KNOCKBACK_DONE", 0.2, []],
	[3, 1, get_icon_path("Damage.png"), ["Heavy Blows I", multipiler_string("stun duration", 20)], "STUN", 0.2, []],
	[4, 1, get_icon_path("Defense.png"), ["Stamina I", multipiler_string("hp", 30)], "HP", 0.3, []],
	[5, 1, get_icon_path("Defense.png"), ["Armor I", multipiler_string("damage taken", 10)], "DEFENSE", 0.1, []],
	[6, 1, get_icon_path("Defense.png"), ["Stability I", multipiler_string("knockback taken", 10)], "KNOCKBACK_TAKEN", 0.1, []],
	
	[7, 2, get_icon_path("Agility.png"), ["Quickness II", multipiler_string("agility", 20)], "AGILITY", 0.2, [0]],
	[8, 2, get_icon_path("Damage.png"), ["Attack II", multipiler_string("damage", 35)], "ATTACK", 0.35, [1]],
	[9, 2, get_icon_path("Damage.png"), ["Strength II", multipiler_string("knockback dealt", 30)], "KNOCKBACK_DONE", 0.3, [2]],
	[10, 2, get_icon_path("Damage.png"), ["Heavy Blows II", multipiler_string("stun duration", 30)], "STUN", 0.3, [3]],
	[11, 2, get_icon_path("Defense.png"), ["Stamina II", multipiler_string("hp", 70)], "HP", 0.7, [4]],
	[12, 2, get_icon_path("Defense.png"), ["Armor II", multipiler_string("damage taken", 30)], "DEFENSE", 0.3, [5]],
	[13, 2, get_icon_path("Defense.png"), ["Stability II", multipiler_string("knockback taken", 20)], "KNOCKBACK_TAKEN", 0.2, [6]],
	
	[14, 2, "res://icon.svg", ["Big Punch", attack_string("Big Punch")], "BIG_ATTACK", 0, []],
	[15, 1, "res://icon.svg", ["Iron Defense", attack_string("Iron Defense")], "SPECIAL_ATTACK", 0, []],
	[16, 2, "res://icon.svg", ["Ground Slam", attack_string("Ground Slam")], "GROUND_ATTACK", 0, []],
	[17, 2, "res://icon.svg", ["Tackle", attack_string("Tackle")], "DASH_ATTACK", 0, []],
	[18, 2, "res://icon.svg", ["Plummet", attack_string("Plummet")], "PLUMMET", 0, []],
	[19, 2, "res://icon.svg", ["Plummet+", attack_upgrade_string("Plummet")], "PLUMMET_PLUS", 0, []],
	
	[20, 2, "res://icon.svg", ["Glowing Shell", unlock_string("shield")], "SHIELD", 0, []],
	[21, 1, "res://icon.svg", ["Roll", unlock_string("roll")], "ROLL", 0, []],
	[22, 2, "res://icon.svg", ["Dash", unlock_string("dash")], "DASH", 0, []],
	[23, 2, "res://icon.svg", ["Wall Jump I", unlock_string("wall jump")], "WALL_JUMP", 0, []],
	[24, 2, "res://icon.svg", ["Triple Jump", unlock_string("triple jump")], "TRIPLE_JUMP", 0, []],
	[25, 2, "res://icon.svg", ["Charged Jump", unlock_string("charged jump (hold down while jumping to charge, release down to jump)")], "CHARGED_JUMP", 0, []],
	
	[26, 2, "res://icon.svg", ["True Sight", ability_string("True Sight", "(Passive)")], "TRUE_SIGHT", 0, []],
	[27, 2, "res://icon.svg", ["Medic", ability_string("Health Regeneration", "(1/sec)")], "HEALTH_REGEN", 1, []],
	[28, 2, "res://icon.svg", ["Vampire", ability_string("Lifesteal", "(30%)")], "LIFESTEAL", 0.3, []],
	[29, 2, "res://icon.svg", ["Fast Learner", ability_string("Bonus EXP", "(50%)")], "BONUS_EXP", 0.3, []],
	[30, 2, "res://icon.svg", ["Value Pack", ability_string("Bonus Healing", "(50%)")], "BONUS_HEALING", 0.5, []],
]

# level, t1, t2, t3, t4, upgraded TODO
var level_percentage = [
	[0, 0, 0, 0, 0, 0],
	[1, 1, 0, 0, 0, 0],
	[2, 0.8, 0.2, 0, 0, 0.1],
	[3, 0.5, 0.5, 0, 0, 0.15],
	[4, 0.2, 0.8, 0, 0, 0.2],
	[5, 0.1, 0.7, 0.2, 0, 0.25],
	[6, 0, 0.5, 0.5, 0, 0.3],
	[7, 0, 0.2, 0.8, 0, 0.35],
	[8, 0, 0.05, 0.9, 0.05, 0.4],
	[9, 0, 0, 0.85, 0.15, 0.45],
	[10, 0, 0, 0.5, 0.5, 0.5]
]

func get_icon_path(file_name: String):
	return "res://Playerdata/Abilities/%s" % [file_name]

func multipiler_string(stat: String, value: float):
	return default_strings["MULTIPLIER"] % [stat, value]
	
func unlock_string(unlock: String):
	return default_strings["UNLOCK"] % [unlock]
	
func attack_string(attack: String):
	return default_strings["ATTACK"] % [attack]
	
func attack_upgrade_string(attack: String):
	return default_strings["ATTACK_UPGRADE"] % [attack]

func ability_string(ability: String, text: String):
	return default_strings["ABILITY"] % [ability, text]
	
func ability_upgrade_string(ability: String, text: String):
	return default_strings["ABILITY_UPGRADE"] % [ability, text]
