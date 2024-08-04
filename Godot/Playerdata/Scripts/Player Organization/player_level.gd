class_name player_level
extends Node

var max_exp : int = 100
var level : int
var experience : int 

signal leveled

func _ready():
	set_physics_process(false)

func gain_exp(gain : int) -> int:
	var levels = 0
	experience += gain
	while experience >= max_exp:
		level_up()
		levels += 1
	return levels
		
func level_up():
	level += 1
	experience -= max_exp
	leveled.emit()
