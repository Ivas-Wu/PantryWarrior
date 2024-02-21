class_name player_level
extends Node

var max_exp : int = 100
var level : int
var exp : int 

func _ready():
	set_physics_process(false)

func gain_exp(gain : int):
	exp += gain
	if exp >= max_exp:
		level_up()
		
func level_up():
	level += 1
	exp -= max_exp
	
