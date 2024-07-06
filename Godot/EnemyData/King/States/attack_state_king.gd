class_name attack_state_king
extends State

signal defend

var king : king
var current_sprite
var flip_direction = 1
func _ready():
	king = get_tree().get_first_node_in_group("Boss")
	set_physics_process(false)
	
func _enter_state() -> void:
	king.idle_attack.visible = true
	king.character_animations.play("AttackIdle")
	make_hand()
	set_physics_process(true)

func _exit_state() -> void:
	cleanup()
	king.idle_attack.visible = false
	if current_sprite: current_sprite.visible = false
	set_physics_process(false)

func _physics_process(delta): pass
	
func handle_state():
	if not king.handle_enemy_finder():
		cleanup()
		pick_attack()
	else:
		remove_hand()

func make_hand():
	king.make_hand.visible = true
	king.attack_animations.play("MakeHand")
	set_flip()
	flip(king.make_hand)
	
func hand_made():
	king.make_hand.visible = false
	pick_attack()
	
func remove_hand():
	king.attack_animations.play("RemoveHand")

func hand_removed():
	defend.emit()
		
func pick_attack():
	if king.random_number > 0.5:
		king.scythe_sprite.visible = true
		current_sprite = king.scythe_sprite
		king.attack_animations.play("ScytheSwing")
	else:
		king.hammer_sprite.visible = true
		current_sprite = king.hammer_sprite
		king.attack_animations.play("HammerSwing")
	flip(current_sprite)
		
func cleanup():
	king.attack_animations.play("RESET")
	king.make_hand.visible = false

func flip(sprite: Sprite2D):
	sprite.position.x = flip_direction * abs(sprite.position.x)
	sprite.scale.x = flip_direction * abs(sprite.scale.x)

func set_flip():
	flip_direction = -1 if king.enemy_finder_ray.target_position.x < 0 else 1
