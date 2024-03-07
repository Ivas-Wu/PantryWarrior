class_name attack_state
extends State

signal previous
signal idle

var player : Player
var flip : bool = false

func _ready():
	set_physics_process(false)
	player = get_tree().get_first_node_in_group("Player")
	
func _enter_state() -> void:
	set_physics_process(true)
	player.hit_box.already_hit = false
	#flip animation to face direction player is facing
	flip = player.animated_sprite_2d.flip_h
	flip_scale()
	#take first attack in the queue
	var attack = player.attack_queue[0]
	#handle animations
	player.animated_sprite_2d.visible = false
	player.attack_animation.visible = true
	match attack:
		"Attack":
			handle_basic_attack()
		"BigAttack":
			if player.skill_handler.offense > 0:
				handle_big_attack()
			else:
				prev()
		"SpecialAttack":
			if player.skill_handler.offense > 1:
				handle_special_attack()
			else:
				prev()

func _exit_state() -> void:
	player.attack_queue.pop_front()
	player.animated_sprite_2d.visible = true
	player.attack_animation.visible = false
	player.animation_player.stop()
	player.hit_box_col.disabled = true
	flip_scale()
	set_physics_process(false)

func _physics_process(delta):
	player.velocity = Vector2.ZERO
	player.move_and_slide()

func flip_scale():
	if flip:
		player.scale.x *= -1

func prev():
	set_physics_process(false)
	previous.emit()
	
func handle_basic_attack(): 
	player.animation_player.play("Basic_Attack")
	player.hit_box.set_export_values(100, 5, 0, 0, player.random_number, player.damage)
	
func handle_big_attack(): 
	player.animation_player.play("Big_Attack")
	player.hit_box.set_export_values(300, 8, 1, 0.5, player.random_number, player.damage)
	
func handle_special_attack(): 
	player.animation_player.play("Special_Attack")
	player.hit_box.set_export_values(100, 5, 1, 0, player.random_number, player.damage)
	
func handle_ground_attack(): pass

func attack_finished():
	idle.emit()
