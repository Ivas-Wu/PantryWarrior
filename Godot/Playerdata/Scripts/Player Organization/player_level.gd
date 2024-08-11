class_name player_level
extends Node

var max_exp : int = 10
var current_level : int
var level_queue : Array = []
var experience : int 

signal leveled(level_queue)

func _ready():
	set_physics_process(false)
	
func gain_exp(gain : int):
	experience += gain
	while experience >= max_exp:
		level_up()
	call_deferred("exp_timer_complete")
	
func level_up():
	current_level += 1
	level_queue.append(current_level)
	experience -= max_exp

func exp_timer_complete():
	leveled.emit(level_queue)
	level_queue = []
