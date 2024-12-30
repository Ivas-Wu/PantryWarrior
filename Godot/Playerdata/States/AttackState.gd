class_name attack_state
extends State

signal previous
signal idle

func _enter_state() -> void:
	set_physics_process(true)
	player.hit_box.already_hit = false
	if player.sprite_script.set_current_sprite(player.attack_animation):
		player.hit_box.scale.x = -abs(player.hit_box.scale.x)
	else:
		player.hit_box.scale.x = abs(player.hit_box.scale.x)
		
	player.allow_flip = false
	
	#take first attack in the queue
	var attack = player.attack_queue[0]

	match attack:
		"Attack":
			handle_basic_attack()
		"BigAttack":
			if skills[skills_enum.BIG_ATTACK]:
				handle_big_attack()
			else:
				prev()
		"SpecialAttack":
			if skills[skills_enum.SPECIAL_ATTACK]:
				handle_special_attack()
			else:
				prev()
		"GroundAttack":
			if skills[skills_enum.GROUND_ATTACK]:
				handle_ground_attack()
			else:
				prev()

func _exit_state() -> void:
	player.enable_hurtbox()
	player.attack_queue.pop_front()
	player.hit_box_col.set_deferred("disabled",true)
	player.allow_flip = true
	
	player.sprite_script.set_current_sprite(player.animated_sprite_2d) # update to happen at the start of states
	player.animation_player.play("RESET")
	set_physics_process(false)

func _physics_process(delta):
	player.velocity = Vector2.ZERO
	player.move_and_slide()

func prev():
	set_physics_process(false)
	previous.emit()
	
func handle_basic_attack(): 
	player.animation_player.play("Basic_Attack")
	player.hit_box.set_export_values(100, 5, 0, 0, player.random_number, player.damage, player.knockback, player.stun)
	
func handle_big_attack(): 
	player.animation_player.play("Big_Attack")
	player.hit_box.set_export_values(300, 8, 1, 0.3, player.random_number, player.damage, player.knockback, player.stun)
	
func handle_special_attack(): 
	player.animation_player.play("Special_Attack")
	player.hit_box.set_export_values(100, 5, 1, 0, player.random_number, player.damage, player.knockback, player.stun)
	player.disable_hurtbox()
	
func handle_ground_attack(): pass

func attack_finished():
	idle.emit()
