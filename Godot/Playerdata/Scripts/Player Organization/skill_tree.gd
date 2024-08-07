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

# index, icon, description, ENUM, modifier, tier, prereq[]
var skills_list = [
	[0, "res://icon.svg", "Damage +0.1", "ATTACK", 0.1, 1, []],
	[1, "res://icon.svg", "Roll", "ROLL", 0, 1, []],
	[2, "res://icon.svg", "Dash", "DASH_ATTACK", 0, 1, []],
	[3, "res://icon.svg", "Agility + 0.1", "AGILITY", 0.1, 1, []],
	[4, "res://icon.svg", "Defense + 0.1", "DEFENSE", 0.1, 1, []],
	[5, "res://icon.svg", "Knock Back + 0.1", "KNOCKBACK_DONE", 0.1, 1, []],
	[6, "res://icon.svg", "HP + 0.1", "HP", 0.1, 1, []]
]

# level, t1, t2, t3, t4, upgraded TODO
var level_percentage = [
	[0, 0, 0, 0, 0],
	[1, 1, 0, 0, 0],
	[2, 0.8, 0.2, 0, 0],
	[3, 0.5, 0.5, 0, 0],
	[4, 0.2, 0.8, 0, 0],
	[5, 0.1, 0.7, 0.2, 0],
	[6, 0, 0.5, 0.5, 0],
	[7, 0, 0.2, 0.8, 0],
	[8, 0, 0.05, 0.9, 0.05],
	[9, 0, 0, 0.85, 0.15],
	[10, 0, 0, 0.5, 0.5]
]
