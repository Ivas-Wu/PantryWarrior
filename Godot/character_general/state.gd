class_name State
extends Node

signal state_finished

var player : Player
var skills
var skills_enum

func _enter_state(): pass
func _exit_state(): pass
func _ready():
	init()
	 
func init():
	set_physics_process(false)
	player = get_tree().get_first_node_in_group("Player")
	var skill_handler_raw = player.get_node_or_null("Scripts/skill_handler")
	if skill_handler_raw == null:
		await skill_handler_raw.initialized
		
	skills = skill_handler_raw.skill_variables
	skills_enum = skill_handler_raw.SkillVariables
