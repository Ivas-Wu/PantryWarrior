class_name king
extends base_character_class

@onready var enemy_finder_ray = $EnemyFinder

#animations
@onready var character_animations = $CharacterAnimations
@onready var attack_animations = $AttackAnimations
@onready var defense_animation = $DefenseAnimation

#states
@onready var fsm = $FiniteStateMachine
@onready var idle_state_king = $FiniteStateMachine/idle_state_king
@onready var attack_state_king = $FiniteStateMachine/attack_state_king
@onready var defend_state_king = $FiniteStateMachine/defend_state_king

#sprit sheets
#Character
@onready var idle = $Idle
@onready var idle_attack = $IdleAttack

#Weapon
@onready var hammer_sprite = $HammerSprite
@onready var scythe_sprite = $ScytheSprite
@onready var make_hand = $MakeHand

#Shield
@onready var temp_shield = $TempShield
@onready var shield_push = $ShieldPush/CollisionPolygon2D

#Timers
@onready var projectile_timer = $Timers/ProjectileTimer

@onready var health_bar = $HealthBar

var player : Player
var in_safety: bool = false
var projectile_count: int = 5
var invul: bool = false

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	set_states()
	hp = 400
	reset_values()

func reset_values():
	current_hp = hp
	health_bar.min_value = 0
	health_bar.max_value = hp
	set_healthbar()
	
func set_states():
	fsm.change_state(fsm.state)
	idle_state_king.defend.connect(fsm.change_state.bind(defend_state_king))
	idle_state_king.attack.connect(fsm.change_state.bind(attack_state_king))
	
	attack_state_king.defend.connect(fsm.change_state.bind(defend_state_king))
	defend_state_king.attack.connect(fsm.change_state.bind(attack_state_king))
	
func _process(delta):
	random_number = rng.randf()
	if projectile_timer.time_left == 0 and get_node("Projectiles").get_child_count() == 0:
		generate_projectiles()
		projectile_timer.start()
	
func handle_enemy_finder() -> bool:
	var collision_object = enemy_finder_ray.get_collider()
	var direction_to_player = global_position.direction_to(player.global_position)
	enemy_finder_ray.target_position = direction_to_player * stat_data.vision_range
	return collision_object == player

func create_projectile(initial_velocity: Vector2, bounce: int): #TODO
	var projectile = preload("res://EnemyData/King/Projectile/projectile.tscn").instantiate().with_values(initial_velocity, bounce)
	get_node("Projectiles").add_child(projectile)
	projectile.global_position = global_position + Vector2(0, -50)

func generate_projectiles():
	var rng = RandomNumberGenerator.new()
	var vel = Vector2.ZERO
	for n in projectile_count:
		vel = Vector2(rng.randf_range(-400,400),rng.randf_range(-800,0))
		create_projectile(vel, projectile_count - 2)
	projectile_count += 1

func take_damage(damage: float) -> bool: 
	if invul: return false
	var is_dead = false
	if current_hp <= damage: 
		handle_death()
		is_dead = true
	else: 
		current_hp -= damage
		set_healthbar()
	if not is_dead:
		invul = true
	return is_dead
	
func handle_stun(duration: float): pass

func set_healthbar():
	health_bar.value = current_hp 

func handle_death(): queue_free()

func _on_safe_area_body_entered(body):
	if body is Player:
		in_safety = true

func _on_safe_area_body_exited(body):
	if body is Player:
		in_safety = false

func _on_enemy_hurt_box_area_entered(hitbox : hitbox_base):
	take_damage(hitbox.damage if hitbox else 0)
