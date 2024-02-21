class_name Player
extends CharacterBody2D

#exports
@export var movement_data: PlayerMovementData
@export var stat_data: PlayerStatsData

#default to character class
@onready var collision_shape = $CollisionShape
@onready var coyote_jump_timer = $TimeHandler/CoyoteJumpTimer as Timer
@onready var stun_timer = $TimeHandler/StunTimer
@onready var health_bar = $CanvasLayer/HealthBar
@onready var starting_position = global_position

#scripts
@onready var skill_handler = $Scripts/skill_handler
@onready var calculate_stats = $Scripts/calculate_stats
@onready var level_handler = $Scripts/level_handler

#from character model
@onready var harzard_detector = $CharacterAttributes/HarzardDetector
@onready var animated_sprite_2d = $CharacterAttributes/AnimatedSprite2D
@onready var animation_player = $CharacterAttributes/AttackingAnimationPlayer as AnimationPlayer
@onready var hit_box = $CharacterAttributes/HitBox
@onready var hurt_box = $CharacterAttributes/HurtBox
@onready var character_collision_shape = $CharacterAttributes/CharacterCollisionShape/CollisionShape
@onready var attack_animation = $CharacterAttributes/Attacking

#States
@onready var fsm = $States as FiniteStateMachine
@onready var jump_state = $States/jump_state as jump_state
@onready var falling_state = $States/falling_state as falling_state
@onready var running_state = $States/running_state as running_state
@onready var idle_state = $States/idle_state as idle_state
@onready var attack_state = $States/attack_state as attack_state
@onready var rolling_state = $States/rolling_state as rolling_state

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#Player Stats
var air_jump : int = 0
var hp : int = 0
var speed : int = 0
var jump : int = 0
var acceleration : int = 0
var damage : int = 0 # damage + speed + knock back
var defense : int = 0 # damage reduction
var stablity : int = 0 # knock back on you

#changes as you play
var current_hp : int
var invulnerability_frames : int
var input_axis : int = 0
var attack_queue : Array = []

func _ready():
	reset_values()
	set_health_bar()
	calculate_character_stats()
	set_states()
	
func set_collision_shape():
	collision_shape.shape = character_collision_shape.shape
	collision_shape.transform = character_collision_shape.transform

func set_states():
	fsm.change_state(fsm.state)
	jump_state.falling.connect(fsm.change_state.bind(falling_state))
	jump_state.previous.connect(fsm.change_to_previous_state.bind())
	
	falling_state.jump.connect(fsm.change_state.bind(jump_state))
	falling_state.landed.connect(fsm.change_state.bind(idle_state))
	falling_state.previous.connect(fsm.change_to_previous_state.bind())
	
	running_state.jump.connect(fsm.change_state.bind(jump_state))
	running_state.idle.connect(fsm.change_state.bind(idle_state))
	running_state.fall.connect(fsm.change_state.bind(falling_state))
	running_state.roll.connect(fsm.change_state.bind(rolling_state))
	
	idle_state.jump.connect(fsm.change_state.bind(jump_state))
	idle_state.run.connect(fsm.change_state.bind(running_state))
	idle_state.fall.connect(fsm.change_state.bind(falling_state))
	idle_state.roll.connect(fsm.change_state.bind(rolling_state))
	
	attack_state.idle.connect(fsm.change_state.bind(idle_state))
	
	rolling_state.idle.connect(fsm.change_state.bind(idle_state))
	rolling_state.previous.connect(fsm.change_to_previous_state.bind())
	
func reset_values():
	#Innate
	velocity = Vector2.ZERO
	global_position = starting_position
	
	#Player Stats
	current_hp = hp
	air_jump = stat_data.air_jump
	invulnerability_frames = 20
	set_collision_shape()
	
	#Prevent bugs
	animated_sprite_2d.visible = true
	attack_animation.visible = false
	animation_player.stop()
	fsm.change_state(idle_state)

func calculate_character_stats():
	calculate_stats.calculate_agility()
	calculate_stats.calculate_offense()
	calculate_stats.calculate_defense()

func _physics_process(delta):
	input_axis = Input.get_axis("Left", "Right")
	if is_on_floor(): air_jump = stat_data.air_jump
	handle_physics(input_axis, delta)
	handle_speed(input_axis, delta)
	handle_damage()
	flip_animation(input_axis)

func handle_physics(input_axis, delta):
	add_gravity(delta)
	handle_friction(input_axis, delta)
	handle_air_resistence(input_axis, delta)

func handle_speed(input_axis, delta):
	if input_axis and not is_attacking():
		if input_axis * velocity.x >= 0:
			if is_on_floor():
				velocity.x = move_toward(velocity.x, input_axis * speed, acceleration * delta)
			else:
				velocity.x = move_toward(velocity.x, input_axis * speed/2, acceleration * delta)
		else:
			if is_on_floor():
				velocity.x = move_toward(velocity.x, input_axis * speed, acceleration * 10 * delta)
			else:
				velocity.x = move_toward(velocity.x, input_axis * speed/2, acceleration * 10 * delta)

func handle_damage():
	if invulnerability_frames == 0:
		handle_damage_collisions()
	else:
		invulnerability_frames -= 1
		if invulnerability_frames == 0:
			if not is_attacking():
				animated_sprite_2d.visible = true
			else:
				attack_animation.visible = true
		else:
			if not is_attacking():
				animated_sprite_2d.visible = not animated_sprite_2d.visible
			else:
				attack_animation.visible = not attack_animation.visible

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

func is_attacking():
	return fsm.state == attack_state
		
func handle_damage_collisions():
	var direction = Vector2.ZERO
	var knock_x = 0
	var knock_y = 0
	var damage = 0
	var stun = 0
	var hurt_overlap = hurt_box.get_overlapping_areas()
	var hazard_overlap = harzard_detector.get_overlapping_areas()
	if not hurt_overlap.is_empty(): 
		for area in hurt_overlap:
			if area.collision_layer == 128 and not area.already_hit:
				var dir = hurt_box.global_position.direction_to(area.global_position).normalized()
				direction -= dir
				knock_x += area.knock_back * dir.x
				knock_y += area.knock_back * dir.y
				if area.damage > damage:
					damage = area.damage
				if area.stun_time > stun:
					stun = area.stun_timer
		
	if not hazard_overlap.is_empty():
		for area in hazard_overlap:
			if area.collision_layer == 4:
				var dir = harzard_detector.global_position.direction_to(area.global_position).normalized()
				direction -= dir
				knock_x += area.knock_back * dir.x
				knock_y += area.knock_back * dir.y
				if area.damage > damage:
					damage = area.damage

	if damage != 0 and not take_damage(damage):
		handle_knockback(direction, abs(knock_x) + abs(knock_y))
		handle_stun(stun)

func take_damage(damage) -> bool:
	var is_dead = false
	damage = damage / defense
	if current_hp <= damage: 
		handle_death()
		is_dead = true
	else: 
		invulnerability_frames = stat_data.invulnerability_frames
		current_hp -= damage
	set_health_bar()
	return is_dead
	
func handle_knockback(direction: Vector2, knock_back: int):
	velocity.x = move_toward(velocity.x, ((direction.x / abs(direction.x)) * knock_back) / stablity, (knock_back*knock_back)/stablity)
	velocity.y = move_toward(velocity.y, ((direction.y / abs(direction.y)) * knock_back) / stablity, (knock_back*knock_back)/stablity)
		
func handle_stun(duration: float):
	if duration == 0: duration = 0.001
	stun_timer.wait_time = duration / stablity
	stun_timer.start()
	
func handle_death() :
	#TODO changes after death like item loss etc..
	handle_respawn()
	
func handle_respawn():
	reset_values()
	
func heal(value: int):
	current_hp = min(current_hp + value, hp)
	set_health_bar()

func set_health_bar():
	health_bar.set_health_bar(current_hp)

func _on_harzard_detector_area_entered(hazard: Hazard):
	if invulnerability_frames > 0 or take_damage(hazard.damage): return
	handle_knockback(-velocity, hazard.knock_back)

func _on_hurt_box_area_entered(hitbox : EnemyHitBox):
	if invulnerability_frames > 0 or take_damage(hitbox.damage) or hitbox.already_hit: return
	hitbox.already_hit = true
	handle_knockback(global_position - hitbox.global_position, hitbox.knock_back)
	handle_stun(hitbox.stun_time)

func _input(event : InputEvent):
	if is_on_floor():
		if event.is_action_pressed("Down") :
			position.y += 1
		if attack_queue.is_empty(): #currently only takes one action at a time due to long animations
			if event.is_action_pressed("Attack"):
				attack_queue.append("Attack")
			elif event.is_action_pressed("BigAttack"):
				attack_queue.append("BigAttack")
			elif event.is_action_pressed("SpecialAttack"):
				attack_queue.append("SpecialAttack")
			
			if not attack_queue.is_empty():
				fsm.change_state(attack_state)
