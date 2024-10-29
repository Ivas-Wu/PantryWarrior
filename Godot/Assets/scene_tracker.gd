extends Node

var saved_stats_files = preload("res://Assets/world_data.tres")
var scene_number : int = 0:
	get:
		return scene_number
	set(value):
		scene_number = value

func _ready():
	scene_number = saved_stats_files._scene

func _process(delta):
	pass
