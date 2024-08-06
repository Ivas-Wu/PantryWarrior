class_name calculate_stats
extends Node

var player : Player

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	set_physics_process(false)
	
func calculate_agility():
	player.speed = player.movement_data.speed
	player.jump = player.movement_data.jump_velocity 
	player.acceleration = player.movement_data.acceleration
	#player.speed = player.movement_data.speed + player.skill_handler.agility * (5 + player.skill_handler.agility)
	#player.jump = player.movement_data.jump_velocity - player.skill_handler.agility * (3 + player.skill_handler.agility)
	#player.acceleration = player.movement_data.acceleration + player.skill_handler.agility * (35 + player.skill_handler.agility)
	
func calculate_offense():
	player.damage = 1 + player.skill_handler.attack
	player.animation_player.speed_scale = player.damage 
	
func calculate_defense():
	var old_max = player.hp
	player.hp = player.stat_data.hp + player.skill_handler.hp
	if player.hp > old_max:
		player.current_hp += player.hp - old_max
	player.defense = 1 + player.skill_handler.defense
	player.stablity = 1 + player.skill_handler.knockback_taken
	player.knockback = 1 + player.skill_handler.knockback_done
	player.stun = 1 + player.skill_handler.stun
	#player.max_invulnerablity_frames = player.stat_data.invulnerability_frames * (1 + player.skill_handler.defense)

