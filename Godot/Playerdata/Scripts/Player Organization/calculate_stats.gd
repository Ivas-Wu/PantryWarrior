class_name calculate_stats
extends Node

var player : Player
var skills
var skills_enum

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	set_physics_process(false)
	var skill_handler_raw = player.get_node_or_null("Scripts/skill_handler")
	if skill_handler_raw == null: #just in case skill handler is init after a state
		await skill_handler_raw.initialized
	skills = skill_handler_raw.skill_variables
	skills_enum = skill_handler_raw.SkillVariables
	
func calculate_agility():
	player.speed = player.movement_data.speed * (1 + skills[skills_enum.AGILITY])
	player.jump = player.movement_data.jump_velocity * (1 + skills[skills_enum.AGILITY])
	player.acceleration = player.movement_data.acceleration * (1 + skills[skills_enum.AGILITY])
	
func calculate_offense():
	player.damage = 1 + skills[skills_enum.ATTACK]
	player.knockback = 1 + skills[skills_enum.KNOCKBACK_DONE]
	player.stun = 1 + skills[skills_enum.STUN]
	player.animation_player.speed_scale = player.damage 
	
func calculate_defense():
	var old_max = player.hp
	player.hp = player.stat_data.hp * skills[skills_enum.HP]
	if player.hp > old_max:
		player.current_hp += player.hp - old_max
	player.defense = 1 + skills[skills_enum.DEFENSE]
	player.stablity = 1 + skills[skills_enum.KNOCKBACK_TAKEN]
	player.max_invulnerablity_frames = player.stat_data.invulnerability_frames * (1 + skills[skills_enum.INVULNERABILITY])

