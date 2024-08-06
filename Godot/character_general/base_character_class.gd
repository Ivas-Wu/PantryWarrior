class_name base_character_class
extends CharacterBody2D

#exports
@export var movement_data: Resource
@export var stat_data: Resource
@export var harzard_detector: Area2D
@export var harzard_detector_col: CollisionShape2D
@export var character_collision_polygon: CollisionPolygon2D
@export var wall_left: RayCast2D
@export var wall_right: RayCast2D

@export var hit_box: hitbox_base
@export var hit_box_col: hitbox_collision_shape_base
@export var hurt_box: Area2D
@export var hurt_box_col: CollisionPolygon2D
@export var animated_sprite_2d : AnimatedSprite2D

@export var exp_on_kill : int = 0

@export var hit_effect: PackedScene = null

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#changes as you play
var current_hp : float
var input_axis : int = 0
var invulnerability_frames : int 

var hp : int = 0
var speed : float = 0
var jump : float = 0
var acceleration : int = 0

var rng = RandomNumberGenerator.new()
var random_number : float
var max_invulnerablity_frames : int
var pushed : bool = false
var wall_jump_flag : bool = false

func _ready():
	pass

func _process(delta):
	pass

func handle_knockback(source_location: Vector2, knock_back: int): pass
func take_damage(damage: float) -> bool: return false
func handle_stun(duration: float): pass
func gain_exp(experience: int): pass
func enter_damaged_state(): pass
func handle_death(): pass
func handle_push(direction: Vector2): pass
func handle_physics(input_axis, delta):
	add_gravity(delta)
	handle_friction(input_axis, delta)
	handle_air_resistence(input_axis, delta)
	
func handle_friction(input_axis, delta):
	if input_axis: return
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.friction * delta)

func handle_air_resistence(input_axis, delta):
	if input_axis: return
	if not is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.air_resistence * delta)

func add_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta * movement_data.gravity_scale

func flip_animation(input_axis):
	if input_axis:
		animated_sprite_2d.flip_h = input_axis < 0

func handle_speed(input_axis, delta):
	if input_axis:
		var a = acceleration
		var s = speed
		if input_axis * velocity.x >= 0:
			if not is_on_floor():
				s *= 0.75
				if pushed: a *= 0.5
		else:
			a *= 10
			if not is_on_floor():
				s *= 0.75
				if pushed: 
					a *= 0.05
					s *= 0.5
		velocity.x = move_toward(velocity.x, input_axis * s, a * delta)

# Custom is on wall with more flexiblity
func near_wall():
	if not wall_left or not wall_right: return
	return wall_right.is_colliding() or wall_left.is_colliding()

func direction_to_wall():
	if not wall_left or not wall_right: return
	if wall_right.is_colliding():
		return 1
	elif wall_left.is_colliding():
		return -1
	else: 
		return 0
	
func create_effect(effect: PackedScene, location: Vector2 = global_position):
	if effect:
		var ef = effect.instantiate()
		get_tree().current_scene.add_child(ef)
		ef.global_position = location
		ef.get_node("AnimationPlayer").play("Hit")
	
func handle_time_slow(duration : float):
	set_physics_process(false)
	Engine.time_scale = 0
	await(get_tree().create_timer(duration, true, false, true).timeout)
	Engine.time_scale = 1
	set_physics_process(true)
	
	
func set_hurtbox_col():
	hurt_box_col.polygon = character_collision_polygon.polygon
	hurt_box_col.scale.x = character_collision_polygon.scale.x

func _on_harzard_detector_area_entered(hazard: Hazard):
	if invulnerability_frames > 0 or take_damage(hazard.damage): return
	handle_knockback(hazard.source.global_position, hazard.knock_back)

func _on_hurt_box_area_entered(hitbox : hitbox_base):
	if hitbox == null: return
	if invulnerability_frames == 0: 
		#hitbox.already_hit = true
		enter_damaged_state()
		create_effect(hit_effect, character_collision_polygon.global_position)
		await(handle_time_slow(hitbox.freeze_frames if hitbox else 0))
		
		if take_damage(hitbox.damage if hitbox != null else 0):
			if hitbox.parent is base_character_class:
				hitbox.parent.gain_exp(exp_on_kill)
		elif hitbox:
			handle_knockback(hitbox.source.global_position, hitbox.knock_back)
			handle_stun(hitbox.stun_time)
	
	if hitbox.parent is projectile_base:
		hitbox.parent.destroy()
