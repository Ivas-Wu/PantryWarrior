class_name musk1
extends base_character_class

@onready var animation_player = $AnimationPlayer as AnimationPlayer
@onready var fsm = $States as FiniteStateMachine

#states
@onready var idle_state = $States/idle_state_musk1
@onready var running_state = $States/running_state_musk1
@onready var basic_attack_state = $States/basic_attack_state_musk1
@onready var stab_attack_state = $States/stab_attack_state_musk1
@onready var big_attack_state = $States/big_attack_state_musk1

#sprit sheets
@onready var basic_attack = $BasicAttack
@onready var big_attack = $BigAttack
@onready var stab_attack = $StabAttack
@onready var running = $Running
@onready var jumping = $Jumping
@onready var idle = $Idle
@onready var sprite_2d = $Sprite2D

#raycasts
@onready var enemy_finder_ray : RayCast2D = $EnemyFinder
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var small_attack_range = $SmallAttackRange
@onready var big_attack_range = $BigAttackRange

#Timer
@onready var movement_update_buffer : Timer = $Timers/MovementUpdateBuffer
@onready var attack_cd : Timer = $Timers/AttackCoolDown
@onready var movement_cd = $Timers/MovementCoolDown

@onready var starting_position = global_position

var direction : Vector2
var player : Player
var current_animation_sprite : Sprite2D = null

func _ready():
	sprite_2d.visible = false
	player = get_tree().get_first_node_in_group("Player")
	set_states()
	hp = stat_data.hp
	acceleration = movement_data.acceleration
	jump = movement_data.jump_velocity
	speed = movement_data.speed
	attack_cd.start()
	reset_values()

func reset_values():
	current_hp = hp
	velocity = Vector2.ZERO
	global_position = starting_position

func set_states():
	fsm.change_state(fsm.state)
	running_state.jump.connect(fsm.change_state.bind(jump_state))
	running_state.idle.connect(fsm.change_state.bind(idle_state))
	running_state.basic.connect(fsm.change_state.bind(basic_attack_state))
	running_state.big.connect(fsm.change_state.bind(big_attack_state))
	running_state.stab.connect(fsm.change_state.bind(stab_attack_state))
	
	idle_state.jump.connect(fsm.change_state.bind(jump_state))
	idle_state.run.connect(fsm.change_state.bind(running_state))
	
	basic_attack_state.idle.connect(fsm.change_state.bind(idle_state))
	big_attack_state.idle.connect(fsm.change_state.bind(idle_state))
	stab_attack_state.idle.connect(fsm.change_state.bind(idle_state))
	
func _physics_process(delta):
	random_number = rng.randf()
	input_axis = get_input_axis(direction)
	handle_physics(input_axis, delta)
	handle_movement(input_axis, delta)
	flip_animation(input_axis)

func get_input_axis(direction_axis: Vector2) -> int:
	var ia = 0
	if direction_axis.x > 0 : ia = 1
	elif direction_axis.x < 0 : ia = -1
	return ia

func handle_movement(input_axis_move, delta):
	handle_speed(input_axis_move, delta)

func handle_enemy_finder() -> bool:
	var collision_object = enemy_finder_ray.get_collider()
	var direction_to_player = global_position.direction_to(player.global_position)
	enemy_finder_ray.target_position = direction_to_player * stat_data.vision_range
	return collision_object == player
	
func get_path_direction() -> Vector2:
	navigation_agent_2d.target_position = player.global_position
	return (navigation_agent_2d.get_next_path_position() - global_position)
	
func handle_big_attack_ray() -> bool:
	var collision_object = big_attack_range.get_collider()
	var direction_to_player = global_position.direction_to(player.global_position)
	big_attack_range.target_position = direction_to_player * stat_data.attack_range_long
	return collision_object == player

func handle_small_attack_ray() -> bool:
	var collision_object = small_attack_range.get_collider()
	var direction_to_player = global_position.direction_to(player.global_position)
	small_attack_range.target_position = direction_to_player * stat_data.attack_range_short
	return collision_object == player
	
func flip_animation(input_axis): 
	if input_axis && current_animation_sprite:
		current_animation_sprite.flip_h = input_axis < 0
		character_collision_polygon.scale.x = -1 if input_axis < 0 else 1

func take_damage(damage: float) -> bool: return false
func handle_stun(duration: float): pass

#end round
func handle_death(): pass

func _on_hurt_box_area_entered(hitbox : hitbox_base):
	take_damage(hitbox.damage if hitbox else 0)
