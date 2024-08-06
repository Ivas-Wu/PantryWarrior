class_name load_game
extends Node

@export var player : Player
var saved_stats_files = "res://Playerdata/Resource/player_current_stats.tres"

func _ready():
	pass

func _process(delta):
	pass
	
func load_game():
	if ResourceLoader.exists(saved_stats_files):
		var saved_stats = ResourceLoader.load(saved_stats_files)
		player.current_hp = saved_stats.current_hp if saved_stats.current_hp > 0 else player.stat_data.hp 
	else:
		player.current_hp = player.stat_data.hp 
