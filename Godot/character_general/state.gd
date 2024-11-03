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
	if skill_handler_raw == null: #just in case skill handler is init after a state
		await skill_handler_raw.initialized
		
	skills = skill_handler_raw.skill_variables
	skills_enum = skill_handler_raw.SkillVariables

func check_jump() -> bool:
	return Input.is_action_just_pressed(input_stringname.Up)
	
func check_roll() -> bool:
	return Input.is_action_just_pressed("Roll") and skills[skills_enum.ROLL] and player.roll_timer.time_left == 0

func check_tackle() -> bool:
	return Input.is_action_just_pressed("Dash") and skills[skills_enum.DASH_ATTACK] and abs(player.velocity.x) > player.speed/2

func check_plummet() -> bool:
	return Input.is_action_just_pressed(input_stringname.Down) and skills[skills_enum.PLUMMET]

func check_attack() -> bool:
	return not player.attack_queue.is_empty() and player.attack_timer.time_left == 0

func handle_wall_jump() -> bool:
	var dtw = player.direction_to_wall()
	var input = (dtw < 0 and Input.is_action_just_pressed(input_stringname.Right)) or (dtw > 0 and Input.is_action_just_pressed(input_stringname.Left))
	return player.near_wall() and input
