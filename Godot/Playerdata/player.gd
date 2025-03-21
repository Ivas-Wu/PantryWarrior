class_name Player
extends base_character_class

#default to character class
@onready var collision_polygon = $CollisionPolygon 
@onready var coyote_jump_timer = $TimeHandler/CoyoteJumpTimer as Timer
@onready var stun_timer = $TimeHandler/StunTimer as Timer
@onready var roll_timer = $TimeHandler/RollTimer as Timer
@onready var attack_timer = $TimeHandler/AttackTimer as Timer
@onready var health_regen_timer = $TimeHandler/HealthRegenTimer as Timer

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
@onready var walljump_state = $States/walljump_state as walljump_state

#Player Stats
var air_jump : int = 1
var max_air_jump : int = 1
var damage : float = 1 # damage + animation speed
var knockback : float = 1 # multiplier
var stun : float = 1 # multiplier
var defense : float = 1 # damage reduction
var stablity : float = 1 # knock back on you

#changes as you play
var attack_queue : Array = []
	
func child_init():
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
	jump_state.wall.connect(fsm.change_state.bind(walljump_state))
	jump_state.previous.connect(fsm.change_to_previous_state.bind())
	
	falling_state.jump.connect(fsm.change_state.bind(jump_state))
	falling_state.landed.connect(fsm.change_state.bind(idle_state))
	falling_state.plummet.connect(fsm.change_state.bind(plummet_state))
	falling_state.wall.connect(fsm.change_state.bind(walljump_state))
	falling_state.previous.connect(fsm.change_to_previous_state.bind())
	
	walljump_state.falling.connect(fsm.change_state.bind(falling_state))
	walljump_state.previous.connect(fsm.change_to_previous_state.bind())
	
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
	
	skill_handler.reprocess_data.connect(calculate_character_stats.bind())
	
func reset_values():
	#Innate
	velocity = Vector2.ZERO
	global_position = starting_position
	
	#Player Stats
	load_game.load_game()
	air_jump = max_air_jump
	invulnerability_frames = 20
	disable_hurtbox()
	set_collision_shape()
	
	#Prevent bugs
	current_sprite = animated_sprite_2d
	animation_player.set_speed_scale(1)
	animation_player.stop()
	fsm.change_state(idle_state)

func calculate_character_stats():
	calculate_stats.calculate_agility()
	calculate_stats.calculate_offense()
	calculate_stats.calculate_defense()
	set_health_bar()
	if skill_handler.skill_variables[skill_handler.SkillVariables.HEALTH_REGEN] > 0: 
		health_regen_timer.start()
		health_regen_timer.timeout.connect(heal.bind(skill_handler.skill_variables[skill_handler.SkillVariables.HEALTH_REGEN]))

func _physics_process(delta):
	random_number = rng.randf()
	input_axis = Input.get_axis(input_stringname.Left, input_stringname.Right)
	
	if is_on_floor(): 
		air_jump = max_air_jump
		pushed = false
	handle_physics(input_axis, delta)
	handle_speed(input_axis, delta)
	handle_damage()
	flip_animation(input_axis)
	set_hurtbox_col()

func handle_damage():
	if invulnerability_frames > 0:
		invulnerability_frames -= 1
		if invulnerability_frames == 0:
			enable_hurtbox()
			sprite_script.get_current_sprite(animated_sprite_2d).visible = true
		else:
			sprite_script.get_current_sprite(animated_sprite_2d).visible = not sprite_script.get_current_sprite(animated_sprite_2d).visible

func take_damage(damage) -> bool:
	var is_dead = false
	damage = damage / defense #TODO
	if current_hp <= damage: 
		handle_death()
		is_dead = true
	else: 
		invulnerability_frames = max_invulnerablity_frames if max_invulnerablity_frames > 0 else 1
		disable_hurtbox()
		current_hp -= damage
	set_health_bar()
	return is_dead

func enter_damaged_state():
	fsm.change_state(idle_state)
	
func disable_hurtbox():
	hurt_box_col.set_deferred("disabled", true)
	hurt_box.set_deferred("monitoring", false)
	harzard_detector_col.set_deferred("disabled", true)

func enable_hurtbox():
	hurt_box_col.set_deferred("disabled", false)
	hurt_box.set_deferred("monitoring", true)
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
	level_handler.gain_exp(experience)

func _input(event : InputEvent):
	if is_on_floor():
		if event.is_action_pressed(input_stringname.Down) :
			position.y += 1
	if attack_queue.is_empty(): #currently only takes one action at a time due to long animations
		if event.is_action_pressed("Attack"):
			attack_queue.append("Attack")
		elif event.is_action_pressed("BigAttack") and skill_handler.skill_variables[skill_handler.SkillVariables.BIG_ATTACK]:
			attack_queue.append("BigAttack")
		elif event.is_action_pressed("SpecialAttack") and skill_handler.skill_variables[skill_handler.SkillVariables.SPECIAL_ATTACK]:
			attack_queue.append("SpecialAttack")
		elif event.is_action_pressed("GroundAttack") and skill_handler.skill_variables[skill_handler.GROUND_ATTACK]:
			attack_queue.append("GroundAttack")
