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

var player : Player
var in_safety: bool = false

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	set_states()
	
func set_states():
	fsm.change_state(fsm.state)
	idle_state_king.defend.connect(fsm.change_state.bind(defend_state_king))
	idle_state_king.attack.connect(fsm.change_state.bind(attack_state_king))
	
	attack_state_king.defend.connect(fsm.change_state.bind(defend_state_king))
	defend_state_king.attack.connect(fsm.change_state.bind(attack_state_king))
	
func _process(delta):
	random_number = rng.randf()
	
func handle_enemy_finder() -> bool:
	var collision_object = enemy_finder_ray.get_collider()
	var direction_to_player = global_position.direction_to(player.global_position)
	enemy_finder_ray.target_position = direction_to_player * stat_data.vision_range
	return collision_object == player


func _on_safe_area_body_entered(body):
	if body is Player:
		in_safety = true

func _on_safe_area_body_exited(body):
	if body is Player:
		in_safety = false
