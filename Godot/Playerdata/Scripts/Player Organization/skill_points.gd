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
