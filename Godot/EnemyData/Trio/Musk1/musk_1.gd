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
@onready var dodge_state = $States/dodge_state_musk1

#sprit sheets
@onready var basic_attack = $BasicAttack
@onready var big_attack = $BigAttack
@onready var stab_attack = $StabAttack
@onready var running = $Running
@onready var jumping = $Jumping
@onready var idle = $Idle
@onready var dodge = $Dodge
@onready var sprite_2d = $Sprite2D
@onready var stab_extension = $StabExtension

#raycasts
@onready var enemy_finder_ray : RayCast2D = $EnemyFinder
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var small_attack_range = $SmallAttackRange
@onready var big_attack_range = $BigAttackRange
@onready var inner_range = $InnerRange

#Timer
@onready var movement_update_buffer : Timer = $Timers/MovementUpdateBuffer
@onready var attack_cd : Timer = $Timers/AttackCoolDown
@onready var movement_cd = $Timers/MovementCoolDown

@onready var starting_position = global_position
@onready var health_bar = $HealthBar

var direction : Vector2
var player : Player
var current_animation_sprite : Sprite2D = null
var override_movement : bool = false

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
	health_bar.min_value = 0
	health_bar.max_value = hp
	set_healthbar()

func set_states():
	fsm.change_state(fsm.state)
	running_state.jump.connect(fsm.change_state.bind(jump_state))
	running_state.idle.connect(fsm.change_state.bind(idle_state))
	running_state.basic.connect(fsm.change_state.bind(basic_attack_state))
	running_state.big.connect(fsm.change_state.bind(big_attack_state))
	running_state.stab.connect(fsm.change_state.bind(stab_attack_state))
	running_state.dodge.connect(fsm.change_state.bind(dodge_state))
	
	idle_state.jump.connect(fsm.change_state.bind(jump_state))
	idle_state.run.connect(fsm.change_state.bind(running_state))
	idle_state.dodge.connect(fsm.change_state.bind(dodge_state))
	
	basic_attack_state.idle.connect(fsm.change_state.bind(idle_state))
	big_attack_state.idle.connect(fsm.change_state.bind(idle_state))
	stab_attack_state.idle.connect(fsm.change_state.bind(idle_state))
	dodge_state.idle.connect(fsm.change_state.bind(idle_state))
	
func _physics_process(delta):
	random_number = rng.randf()
	input_axis = get_input_axis(direction)
	handle_physics(input_axis, delta)
	if not override_movement:
		handle_movement(input_axis, delta)
	flip_animation(input_axis)
	set_hurtbox_col()

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

func handle_inner_ray() -> bool:
	var collision_object = inner_range.get_collider()
	var direction_to_player = global_position.direction_to(player.global_position)
	inner_range.target_position = direction_to_player * 33
	return collision_object == player

func handle_attack_range(basic, big, stab, dodge) -> bool:
	var big_range = handle_big_attack_ray()
	var small_range = handle_small_attack_ray()
	var inner_range = handle_inner_ray()
	
	if inner_range:
		#velocity.x = 0
		if attack_cd.time_left > 0:
			dodge.emit() #dodge
		else:
			if random_number > 0.5:
				dodge.emit()
			else:
				basic.emit()
		return false
	if attack_cd.time_left > 0:
		return true
	if not big_range:
		if random_number > 0.995:
			stab.emit()
		else:
			return true
	elif small_range: #range of both
		if random_number > 0.2:
			basic.emit()
	else: #big attack range only
		#moving away
		if player.velocity.x * enemy_finder_ray.target_position.x < 0:
			if random_number > 0.85:
				big.emit()
		#moving towards
		else:
			if random_number > 0.5:
				big.emit()
	return false
		
func flip_animation(input_axis): 
	if input_axis && current_animation_sprite:
		current_animation_sprite.flip_h = input_axis < 0
		if input_axis < 0:
			character_collision_polygon.scale.x = -abs(character_collision_polygon.scale.x)
			hit_box.scale.x = -abs(hit_box.scale.x)
			stab_extension.position.x = -abs(stab_extension.position.x)
		else:
			character_collision_polygon.scale.x = abs(character_collision_polygon.scale.x)
			hit_box.scale.x = abs(hit_box.scale.x)
			stab_extension.position.x = abs(stab_extension.position.x)

func take_damage(damage: float) -> bool: 
	var is_dead = false
	if current_hp <= damage: 
		handle_death()
		is_dead = true
	else: 
		current_hp -= damage
		set_healthbar()
	return is_dead
	
func handle_stun(duration: float): pass

func set_healthbar():
	health_bar.value = current_hp 

func handle_death(): queue_free()

func _on_enemy_hurt_box_area_entered(hitbox : hitbox_base):
	take_damage(hitbox.damage if hitbox else 0)
