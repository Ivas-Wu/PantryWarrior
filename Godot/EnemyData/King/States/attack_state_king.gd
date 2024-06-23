class_name attack_state_king
extends State

signal defend

var king : king
var current_sprite
var flipped : bool = false

func _ready():
	king = get_tree().get_first_node_in_group("Boss")
	set_physics_process(false)
	
func _enter_state() -> void:
	pick_attack()
	set_physics_process(true)

func _exit_state() -> void:
	cleanup()
	set_physics_process(false)

func _physics_process(delta):
	king.handle_enemy_finder()
	
func handle_state():
	if not king.handle_enemy_finder():
		cleanup()
		pick_attack()
	else:
		defend.emit()
		
func pick_attack():
	if king.enemy_finder_ray.target_position.x < 0:
		flipped = true
	king.idle_attack.visible = true
	king.character_animations.play("AttackIdle")
	if king.random_number > 0.5:
		king.scythe_sprite.visible = true
		current_sprite = king.scythe_sprite
		king.attack_animations.play("ScytheSwing")
	else:
		king.hammer_sprite.visible = true
		current_sprite = king.hammer_sprite
		king.attack_animations.play("HammerSwing")
	if flipped:
		current_sprite.position.x *= -1
		current_sprite.scale.x *= -1
		
func cleanup():
	king.idle_attack.visible = false
	current_sprite.visible = false
	king.attack_animations.play("RESET")
	if flipped:
		current_sprite.position.x *= -1
		current_sprite.scale.x *= -1
		flipped = false
