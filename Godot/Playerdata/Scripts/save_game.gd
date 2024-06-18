class_name save_game
extends Node

@export var player : Player
var saved_stats_files = "res://Playerdata/Resource/player_current_stats.tres"

func _ready():
	pass

func _process(delta):
	pass

func save():
	if ResourceLoader.exists(saved_stats_files):
		var saved_stats = ResourceLoader.load(saved_stats_files)
		saved_stats.current_hp = player.current_hp
		saved_stats.free_skill_pts = player.skill_handler.skill_pts
		saved_stats.agility = player.skill_handler.agility
		saved_stats.offense = player.skill_handler.offense
		saved_stats.defense = player.skill_handler.defense
		saved_stats.dash = player.skill_handler.dash
		saved_stats.special = player.skill_handler.special
		ResourceSaver.save(saved_stats, saved_stats_files)
