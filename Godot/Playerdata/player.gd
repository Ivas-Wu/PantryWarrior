class_name Player
extends base_character_class

#default to character class
@onready var collision_polygon = $CollisionPolygon 
@onready var coyote_jump_timer = $TimeHandler/CoyoteJumpTimer as Timer
@onready var stun_timer = $TimeHandler/StunTimer
@onready var health_bar = $CanvasLayer/HealthBar
@onready var starting_position = global_position

#scripts
@onready var load_game = $Scripts/load_game
@onready var save_game = $Scripts/save_game
@onready var skill_handler = $Scripts/skill_handler
@onready var calculate_stats = $Scripts/calculate_stats
@onready var level_handler = $Scripts/level_handler

#from character model
@onready var animation_player = $CharacterAttributes/AttackingAnimationPlayer as AnimationPlayer
@onready var attack_animation = $CharacterAttributes/Attacking

#States
@onready var fsm = $States as FiniteStateMachine
@onready var jump_state = $States/jump_state as jump_state
@onready var falling_state = $States/falling_state as falling_state
@onready var running_state = $States/running_state as running_state
@onready var idle_state = $States/idle_state as idle_state
@onready var attack_state = $States/attack_state as attack_state
@onready var rolling_state = $States/rolling_state as rolling_state
@onready var dash_state = $States/dash_state as dash_state
@onready var plummet_state = $States/plummet_state as plummet_state

#Player Stats
var air_jump : int = 0
var damage : float = 0 # damage + speed + knock back
var defense : float = 0 # damage reduction
var stablity : float = 0 # knock back on you

#changes as you play
var attack_queue : Array = []

func _ready():
	calculate_character_stats()
	reset_values()
	set_health_bar()
	set_states()
	
func set_collision_shape():
	collision_polygon.polygon = character_collision_polygon.polygon
	collision_polygon.transform = character_collision_polygon.transform

func set_states():
	fsm.change_state(fsm.state)
	jump_state.falling.connect(fsm.change_state.bind(falling_state))
	jump_state.plummet.connect(fsm.change_state.bind(plummet_state))
	jump_state.landed.connect(fsm.change_state.bind(idle_state))
	jump_state.previous.connect(fsm.change_to_previous_state.bind())
	
	falling_state.jump.connect(fsm.change_state.bind(jump_state))
	falling_state.landed.connect(fsm.change_state.bind(idle_state))
	falling_state.plummet.connect(fsm.change_state.bind(plummet_state))
	falling_state.previous.connect(fsm.change_to_previous_state.bind())

	running_state.jump.connect(fsm.change_state.bind(jump_state))
	running_state.idle.connect(fsm.change_state.bind(idle_state))
	running_state.fall.connect(fsm.change_state.bind(falling_state))
	running_state.up.connect(fsm.change_state.bind(jump_state))
	running_state.roll.connect(fsm.change_state.bind(rolling_state))
	running_state.dash.connect(fsm.change_state.bind(dash_state))
	running_state.attack.connect(fsm.change_state.bind(attack_state))
	
	idle_state.jump.connect(fsm.change_state.bind(jump_state))
	idle_state.run.connect(fsm.change_state.bind(running_state))
	idle_state.fall.connect(fsm.change_state.bind(falling_state))
	idle_state.up.connect(fsm.change_state.bind(jump_state))
	idle_state.roll.connect(fsm.change_state.bind(rolling_state))
	idle_state.attack.connect(fsm.change_state.bind(attack_state))
	
	attack_state.idle.connect(fsm.change_state.bind(idle_state))
	attack_state.previous.connect(fsm.change_to_previous_state.bind())
	
	rolling_state.idle.connect(fsm.change_state.bind(idle_state))
	rolling_state.previous.connect(fsm.change_to_previous_state.bind())
	
	dash_state.idle.connect(fsm.change_state.bind(idle_state))
	
	plummet_state.jump.connect(fsm.change_state.bind(jump_state))
	plummet_state.landed.connect(fsm.change_state.bind(idle_state))
	plummet_state.fall.connect(fsm.change_state.bind(falling_state))
	plummet_state.previous.connect(fsm.change_to_previous_state.bind())
	
func reset_values():
	#Innate
	velocity = Vector2.ZERO
	global_position = starting_position
	
	#Player Stats
	load_game.load_game()
	air_jump = stat_data.air_jump
	invulnerability_frames = 20
	disabled_hurt_boxes()
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
	random_number = rng.randf()
	input_axis = Input.get_axis("Left", "Right")
	
	if is_on_floor(): 
		air_jump = stat_data.air_jump
		pushed = false
	handle_physics(input_axis, delta)
	if not is_attacking():
		handle_speed(input_axis, delta)
	handle_damage()
	flip_animation(input_axis)
	set_hurtbox_col()

func handle_damage():
	if invulnerability_frames == 0:
		enabled_hurt_boxes()
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

func is_attacking():
	return fsm.state == attack_state

func take_damage(damage) -> bool:
	var is_dead = false
	damage = damage / defense
	if current_hp <= damage: 
		handle_death()
		is_dead = true
	else: 
		invulnerability_frames = max_invulnerablity_frames
		disabled_hurt_boxes()
		current_hp -= damage
	set_health_bar()
	return is_dead

func enter_damaged_state():
	fsm.change_state(idle_state)
	
func disabled_hurt_boxes():
	hurt_box_col.set_deferred("disabled", true)
	harzard_detector_col.set_deferred("disabled", true)

func enabled_hurt_boxes():
	hurt_box_col.set_deferred("disabled", false)
	harzard_detector_col.set_deferred("disabled", false)
	
func handle_knockback(source_location: Vector2, knock_back: int):
	var launch_direction = source_location.direction_to(hurt_box.global_position).normalized()
	velocity.x = move_toward(velocity.x, (launch_direction.x * knock_back * 200 * movement_data.knock_back) / stablity, (knock_back*40)/stablity)
	velocity.y = move_toward(velocity.y, (launch_direction.y * knock_back * 200 * movement_data.knock_back) / stablity, (knock_back*40)/(stablity))

func handle_stun(duration: float):
	if duration == 0: duration = 0.001
	stun_timer.wait_time = duration / stablity
	stun_timer.start()
	
func handle_death() :
	#TODO changes after death like item loss etc..
	handle_respawn()

func handle_push(direction: Vector2):
	velocity.x += direction.x
	velocity.y += direction.y
	enter_damaged_state()
	
func handle_respawn():
	reset_values()
	
func heal(value: int):
	current_hp = min(current_hp + value, hp)
	set_health_bar()

func set_health_bar():
	health_bar.set_health_bar(current_hp)

func gain_exp(experience: int):
	skill_handler.add_skill_pts(level_handler.gain_exp(experience))

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
			
func handle_wall_jump():
	var dtw = direction_to_wall()
	if near_wall() and ((dtw < 0 and Input.is_action_just_pressed("Right")) or (dtw > 0 and Input.is_action_just_pressed("Left"))):
		wall_jump_flag = true
		animated_sprite_2d.play("WallJump")
		velocity.x = -dtw * 250
		velocity.y = -250

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite_2d.animation == "WallJump":
		wall_jump_flag = false  
