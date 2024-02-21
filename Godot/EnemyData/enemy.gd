class_name Enemy
extends CharacterBody2D

@export var movement_data: EnemyMovementData
@export var stat_data: EnemyStatsData
@export var navigation_agent_2d : NavigationAgent2D
@export var animated_sprite_2d : AnimatedSprite2D
@export var harzard_detector : Area2D
@export var hurt_box : EnemyHurtBox
#Timer
@export var coyote_jump_timer : Timer
@export var movement_update_buffer : Timer
@export var stun_timer : Timer
@export var attack_cd : Timer

#States
@onready var fsm = $FiniteStateMachine as FiniteStateMachine
@onready var enemy_idle_state = $FiniteStateMachine/EnemyIdleState as enemy_idle_state
@onready var enemy_aggro_state = $FiniteStateMachine/EnemyAggroState as enemy_aggro_state
@onready var enemy_wander_state = $FiniteStateMachine/enemy_wander_state as enemy_wander_state
@onready var enemy_attack_state = $FiniteStateMachine/enemy_attack_state as enemy_attack_state
@onready var enemy_damaged_state = $FiniteStateMachine/enemy_damaged_state as enemy_damaged_state
@onready var health_bar = $HealthBar

@onready var enemy_hit_box = $EnemyHitBox as EnemyHitBox
@onready var starting_position = global_position

#Raycasts
@onready var enemy_finder_ray : RayCast2D = $EnemyFinder
@onready var ground_finder_ray : RayCast2D = $Ground
@onready var attack_range_ray : RayCast2D = $AttackRange

var player : Player
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var harzards_list : Dictionary
var current_hp : int
var input_axis : int = 0
var direction : Vector2
var invulnerability_frames : int 
var current_direction : int

var rng = RandomNumberGenerator.new()
var random_number : float

func _ready():
	enemy_idle_state.found.connect(fsm.change_state.bind(enemy_aggro_state))
	enemy_idle_state.wander.connect(fsm.change_state.bind(enemy_wander_state))
	
	enemy_wander_state.found.connect(fsm.change_state.bind(enemy_aggro_state))
	enemy_wander_state.stopped.connect(fsm.change_state.bind(enemy_idle_state))
	
	enemy_aggro_state.lost.connect(fsm.change_state.bind(enemy_idle_state))
	enemy_aggro_state.attack.connect(fsm.change_state.bind(enemy_attack_state))
	
	enemy_attack_state.aggro.connect(fsm.change_state.bind(enemy_aggro_state))
	
	enemy_damaged_state.out.connect(fsm.change_state.bind(enemy_idle_state))
	player = get_tree().get_first_node_in_group("Player")
	reset_values()


func reset_values():
	current_hp = stat_data.hp
	velocity = Vector2.ZERO
	global_position = starting_position
	current_direction = rng.randi_range(0,1)
	fsm.change_state(fsm.state)
	health_bar.min_value = 0
	health_bar.max_value = stat_data.hp
	set_healthbar()

func _physics_process(delta):
	random_number = rng.randf()
	input_axis = get_input_axis(direction)
	handle_physics(input_axis, delta)
	if invulnerability_frames == 0:
		handle_movement(input_axis, delta)
		handle_damage()
		flip_animation(input_axis)
	else:
		invulnerability_frames -= 1
		
func handle_physics(input_axis, delta):
	handle_air_resistence(input_axis, delta)
	handle_friction(input_axis, delta)
	add_gravity(delta)

func handle_movement(input_axis, delta):
	if stun_timer.time_left > 0: return
	#handle_jump(direction)
	handle_speed(input_axis, delta)
	
func handle_damage():
	handle_harzard_collisions()

func flip_animation(input_axis):
	if input_axis:
		animated_sprite_2d.flip_h = input_axis < 0
		
func add_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta * movement_data.gravity_scale

func handle_friction(input_axis, delta):
	if input_axis: return
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.friction * delta)

func handle_air_resistence(input_axis, delta):
	if input_axis: return
	if not is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.air_resistence * delta)
			
func get_input_axis(direction: Vector2) -> int:
	var input_axis = 0
	if direction.x > 0 : input_axis = 1
	elif direction.x < 0 : input_axis = -1
	return input_axis
	
func handle_speed(input_axis, delta):
	if input_axis:
		if input_axis * velocity.x >= 0:
			if is_on_floor():
				velocity.x = move_toward(velocity.x, input_axis * movement_data.speed, movement_data.acceleration * delta)
			else:
				velocity.x = move_toward(velocity.x, input_axis * movement_data.speed/2, movement_data.acceleration * delta)
		else:
			if is_on_floor():
				velocity.x = move_toward(velocity.x, input_axis * movement_data.speed, movement_data.acceleration * 10 * delta)
			else:
				velocity.x = move_toward(velocity.x, input_axis * movement_data.speed/2, movement_data.acceleration * 10 * delta)
		
func handle_jump(direction: Vector2):
	if direction.y * direction.y < 400: direction.y = 0
	var can_jump = is_on_floor() or coyote_jump_timer.time_left > 0.0
	var need_jump = rad_to_deg(direction.angle()) < 0 - stat_data.max_walk_angle && rad_to_deg(direction.angle()) > -180 + stat_data.max_walk_angle
	if can_jump && need_jump:
		velocity.y = movement_data.jump_velocity	

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
	
func handle_harzard_collisions():
	if harzards_list.is_empty(): return 
	for hazard in harzards_list:
		velocity -= harzards_list[hazard] * movement_data.knock_back

func take_damage(damage) -> bool:
	var is_dead = false
	damage = damage * player.damage #TODO
	if current_hp <= damage: 
		handle_death()
		is_dead = true
	else: 
		fsm.change_state(enemy_damaged_state)
		invulnerability_frames = 20
		current_hp -= damage
		set_healthbar()
	return is_dead

func handle_knockback(direction: Vector2, knock_back : int):
	velocity.x = move_toward(velocity.x, (direction.x / abs(direction.x)) * knock_back * movement_data.knock_back, knock_back)
	velocity.y = move_toward(velocity.y, (direction.y / abs(direction.y)) * knock_back * movement_data.knock_back, knock_back/2)

func handle_stun(duration: float):
	if duration == 0: duration = 0.001
	stun_timer.wait_time = duration
	stun_timer.start()

func set_healthbar():
	health_bar.value = current_hp 
	
func handle_death() :
	queue_free()

func _on_harzard_detector_area_entered(hazard: Hazard):
	harzards_list[hazard] = (hazard.position - harzard_detector.global_position)
	if take_damage(hazard.damage): return
	handle_knockback(-velocity, hazard.knock_back)

func _on_harzard_detector_area_exited(hazard):
	if harzards_list.is_empty(): return
	harzards_list.erase(hazard)

func _on_hurt_box_area_entered(hitbox: HitBox):
	if not take_damage(hitbox.damage): 
		handle_knockback(global_position - hitbox.global_position, hitbox.knock_back)
		handle_stun(hitbox.stun_time)
