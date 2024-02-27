class_name skill_points
extends Node

var skill_pts : int = 0
var agility : int = 5
var offense : int = 1
var defense : int = 1
var dash : int = 1
var special : int = 1
#var ult : int = 0

func _ready():	
	set_physics_process(false)

func save(_data):
	pass

func add_skill_pts(pts: int):
	for n in range(pts): skill_pts += 1
	
func add_point(match_int: int):
	if skill_pts == 0: return false
	match match_int:
		0:
			if agility < 5:
				agility += 1
		1:
			if offense < 5:
				offense += 1
		2:
			if defense < 5:
				defense += 1
		3:
			if dash < 5:
				dash += 1
		4:
			if special < 5:
				special += 1
	skill_pts -= 1
	return true

func sub_point(match_int: int):
	var success = true
	match match_int:
		0:
			if agility == 0: success = false
			else: agility -= 1
		1:
			if offense == 0: success = false
			else: offense -= 1
		2:
			if defense == 0: success = false
			else: defense -= 1
		3:
			if dash == 0: success = false
			else: dash -= 1
		4:
			if special == 0: success = false
			else: special -= 1
	skill_pts += 1
	return true
