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
		player.skill_handler.skill_pts = saved_stats.free_skill_pts
		player.skill_handler.agility = saved_stats.agility
		player.skill_handler.offense = saved_stats.offense
		player.skill_handler.defense = saved_stats.defense
		player.skill_handler.dash = saved_stats.dash
		player.skill_handler.special = saved_stats.special
	else:
		player.current_hp = player.stat_data.hp 
		player.skill_handler.skill_pts = 0
		player.skill_handler.agility = 0
		player.skill_handler.offense = 0
		player.skill_handler.defense = 0
		player.skill_handler.dash = 0
		player.skill_handler.special = 0
