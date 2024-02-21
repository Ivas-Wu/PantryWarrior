class_name skill_points
extends Node

var skill_pts : int = 0
var agility : int = 5
var offense : int = 0
var defense : int = 0
var sp1 : int = 0
var sp2 : int = 0
var ult : int = 0

func _ready():
	set_physics_process(false)

func save(data):
	pass
