class_name load_game
extends Node

@export var player : Player
var saved_stats_files = "res://Playerdata/Resource/player_current_stats.tres"
var unlocked_abilities_file = "res://Playerdata/Resource/player_unlocked_abilities.tres"
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
	
	if ResourceLoader.exists(unlocked_abilities_file):
		var unlocked_abilities = ResourceLoader.load(unlocked_abilities_file)
		print(unlocked_abilities.ability_index_list)
