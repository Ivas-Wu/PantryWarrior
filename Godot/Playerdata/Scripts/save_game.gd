class_name save_game
extends Node

@export var player : Player
var saved_stats_files = "res://Playerdata/Resource/player_current_stats.tres"
var unlocked_abilities_file = "res://Playerdata/Resource/player_unlocked_abilities.tres"
func _ready():
	player = get_tree().get_first_node_in_group("Player")

func _process(delta):
	pass

func save():
	if ResourceLoader.exists(saved_stats_files):
		var saved_stats = ResourceLoader.load(saved_stats_files)
		saved_stats.current_hp = player.current_hp
		ResourceSaver.save(saved_stats, saved_stats_files)
	if ResourceLoader.exists(unlocked_abilities_file):
		var unlocked_abilities = ResourceLoader.load(unlocked_abilities_file)
		var temp_dict_arr = []
		for key in player.skill_handler.unlocked_abilities:
			temp_dict_arr.append(key)
		unlocked_abilities.ability_index_list = temp_dict_arr
		ResourceSaver.save(unlocked_abilities, unlocked_abilities_file)
