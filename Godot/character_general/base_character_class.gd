class_name base_character_class
extends CharacterBody2D

#exports
@export var movement_data: Resource
@export var stat_data: Resource
@export var harzard_detector: Area2D
@export var harzard_detector_col: CollisionShape2D
@export var character_collision_shape: CollisionShape2D

@export var hit_box: hitbox_base
@export var hit_box_col: hitbox_collision_shape_base
@export var hurt_box: Area2D
@export var hurt_box_col: CollisionShape2D
@export var animated_sprite_2d : AnimatedSprite2D

@export var exp_on_kill : int = 0

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

func _ready():
	pass

func _process(delta):
	pass

func handle_knockback(source_location: Vector2, knock_back: int): pass
func take_damage(damage: float) -> bool: return false
func handle_stun(duration: float): pass
func gain_exp(experience: int): pass

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

func _on_harzard_detector_area_entered(hazard: Hazard):
	if invulnerability_frames > 0 or take_damage(hazard.damage): return
	handle_knockback(hazard.source, hazard.knock_back)

func _on_hurt_box_area_entered(hitbox : hitbox_base):
	if invulnerability_frames > 0 or hitbox.already_hit: return
	Engine.time_scale = 0
	await(get_tree().create_timer(hitbox.freeze_frames, true, false, true).timeout)
	Engine.time_scale = 1
	if take_damage(hitbox.damage):
		hitbox.parent.gain_exp(exp_on_kill)
	else:
		hitbox.already_hit = true
		handle_knockback(hitbox.source.global_position, hitbox.knock_back)
		handle_stun(hitbox.stun_time)
