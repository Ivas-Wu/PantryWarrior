class_name generic_enemy
extends base_character_class

@export var navigation_agent_2d : NavigationAgent2D

#Timer
@export var coyote_jump_timer : Timer
@export var movement_update_buffer : Timer
@export var stun_timer : Timer
@export var attack_cd : Timer

#States
@onready var fsm = $FiniteStateMachine as FiniteStateMachine
@onready var enemy_aggro_state = $FiniteStateMachine/generic_enemy_aggro_state
@onready var enemy_damaged_state = $FiniteStateMachine/generic_enemy_damaged_state
@onready var enemy_idle_state = $FiniteStateMachine/generic_enemy_idle_state
@onready var enemy_wander_state = $FiniteStateMachine/generic_enemy_wander_state
@onready var enemy_attack_state = $FiniteStateMachine/generic_enemy_attack_state

@onready var health_bar = $HealthBar
@onready var starting_position = global_position

#Raycasts
@onready var enemy_finder_ray : RayCast2D = $EnemyFinder
@onready var ground_finder_ray : RayCast2D = $Ground
@onready var attack_range_ray : RayCast2D = $AttackRange

@onready var animation_player = $AnimationPlayer
@onready var idle = $Idle

var player : Player
var direction : Vector2
var current_direction : int

func child_init():
	set_states()
	set_stats()
	reset_values()

func set_stats():
	player = get_tree().get_first_node_in_group("Player")
	hp = stat_data.hp
	acceleration = movement_data.acceleration
	jump = movement_data.jump_velocity
	speed = movement_data.speed
	
func reset_values():
	current_hp = hp
	velocity = Vector2.ZERO
	global_position = starting_position
	current_direction = rng.randi_range(0,1)
	fsm.change_state(fsm.state)
	health_bar.min_value = 0
	health_bar.max_value = hp
	set_healthbar()

func set_states():
	enemy_idle_state.found.connect(fsm.change_state.bind(enemy_aggro_state))
	enemy_idle_state.wander.connect(fsm.change_state.bind(enemy_wander_state))
	
	enemy_wander_state.found.connect(fsm.change_state.bind(enemy_aggro_state))
	enemy_wander_state.stopped.connect(fsm.change_state.bind(enemy_idle_state))
	
	enemy_aggro_state.lost.connect(fsm.change_state.bind(enemy_idle_state))
	enemy_aggro_state.attack.connect(fsm.change_state.bind(enemy_attack_state))
	
	enemy_attack_state.aggro.connect(fsm.change_state.bind(enemy_aggro_state))
	
	enemy_damaged_state.out.connect(fsm.change_state.bind(enemy_idle_state))
	
func _physics_process(delta):
	random_number = rng.randf()
	input_axis = get_input_axis(direction)
	handle_physics(input_axis, delta)
	if invulnerability_frames == 0:
		handle_movement(input_axis, delta)
		flip_animation(input_axis)
		set_hurtbox_col()
	else:
		invulnerability_frames -= 1

func handle_movement(input_axis_move, delta):
	if stun_timer.time_left > 0: return
	handle_speed(input_axis_move, delta)

func get_input_axis(direction_axis: Vector2) -> int:
	var ia = 0
	if direction_axis.x > 0 : ia = 1
	elif direction_axis.x < 0 : ia = -1
	return ia

#func handle_jump(direction_jump: Vector2):
	#if direction_jump.y * direction_jump.y < 400: direction_jump.y = 0
	#var can_jump = is_on_floor() or coyote_jump_timer.time_left > 0.0
	#var need_jump = rad_to_deg(direction_jump.angle()) < 0 - stat_data.max_walk_angle && rad_to_deg(direction_jump.angle()) > -180 + stat_data.max_walk_angle
	#if can_jump && need_jump:
		#velocity.y = movement_data.jump_velocity

func handle_enemy_finder() -> bool:
	var collision_object = enemy_finder_ray.get_collider()
	var direction_to_player = global_position.direction_to(player.global_position)
	enemy_finder_ray.target_position = direction_to_player * stat_data.vision_range
	return collision_object == player
	
func get_path_direction() -> Vector2:
	navigation_agent_2d.target_position = player.global_position
	return (navigation_agent_2d.get_next_path_position() - global_position)
	
func handle_attack_ray() -> bool:
	var collision_object = attack_range_ray.get_collider()
	var direction_to_player = global_position.direction_to(player.global_position)
	attack_range_ray.target_position = direction_to_player * stat_data.attack_range
	return collision_object == player

func take_damage(damage) -> bool:
	var is_dead = false
	if current_hp <= damage: 
		handle_death()
		is_dead = true
	else: 
		current_hp -= damage
		set_healthbar()
	return is_dead

func enter_damaged_state():
	fsm.change_state(enemy_damaged_state)
	
func handle_knockback(source_location: Vector2, knock_back: int):
	var launch_direction = source_location.direction_to(hurt_box.global_position).normalized()
	velocity.x = move_toward(velocity.x, launch_direction.x * knock_back * 200 * movement_data.knock_back, knock_back * 30)
	velocity.y = move_toward(velocity.y, launch_direction.y * knock_back * 200 * movement_data.knock_back, knock_back * 30)
	
func handle_stun(duration: float):
	if duration == 0: duration = 0.001
	stun_timer.wait_time = duration
	stun_timer.start()

func set_healthbar():
	health_bar.value = current_hp 
	
func handle_death():
	queue_free()
	
func flip_animation(input_axis):
	if input_axis:
		sprite_script.get_current_sprite(idle).flip_h = input_axis < 0
