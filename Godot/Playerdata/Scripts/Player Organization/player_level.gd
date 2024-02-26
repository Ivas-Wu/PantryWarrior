class_name player_level
extends Node

var max_exp : int = 100
var level : int
var experience : int 

func _ready():
	set_physics_process(false)

func gain_exp(gain : int):
	experience += gain
	if experience >= max_exp:
		level_up()
		
func level_up():
	level += 1
	experience -= max_exp
	
