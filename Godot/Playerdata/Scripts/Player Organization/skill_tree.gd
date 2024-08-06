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

var skills_list = [
	[0, "res://icon.svg", "Damage +0.1", "ATTACK", 0.1],
	[1, "res://icon.svg", "Roll", "ROLL"],
	[2, "res://icon.svg", "Dash", "DASH_ATTACK"],
	[3, "res://icon.svg", "Agility + 0.1", "AGILITY", 0.1],
	[4, "res://icon.svg", "Defense + 0.1", "DEFENSE", 0.1]
]
