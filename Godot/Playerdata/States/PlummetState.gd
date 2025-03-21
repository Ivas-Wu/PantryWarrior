class_name plummet_state
extends State

signal landed
signal previous
signal jump
signal fall
	
func _enter_state() -> void:
	if not skills[skills_enum.PLUMMET]: previous.emit()
	elif player.is_on_floor(): landed.emit()
	else:
		player.animated_sprite_2d.play("PlummetFall")
		player.velocity.y += 300
		#set the size of the hitbox
		player.hit_box_col.set_x_y_size(Vector2(5,2.5), Vector2(0.5,-1.25), Vector2(2,2))
		#reset values to let it hit
		player.hit_box.already_hit = false
		player.hit_box_col.disabled = false
		#edit hitbox exports
		player.hit_box.set_export_values(100, 5, 1, 0.1, player.random_number, player.damage, player.knockback, player.stun)
		player.hurt_box_col.disabled = true
		player.collision_mask = 7
		set_physics_process(true)

func _exit_state() -> void:
	if not player.is_on_floor():
		player.velocity.y -= 300
	player.hit_box_col.disabled = true
	player.collision_mask = 23
	set_physics_process(false)

func _physics_process(delta):
	if check_jump():
		jump.emit()
	elif Input.is_action_just_released(input_stringname.Down):
		fall.emit()
	else:
		var in_air = not player.is_on_floor()
		player.move_and_slide()
		if in_air and player.is_on_floor():
			handle_landing()

func handle_landing():
	player.animated_sprite_2d.play("PlummetLand")
	if skills[skills_enum.PLUMMET_PLUS]:
		#set the size of the hitbox
		player.hit_box_col.set_x_y_size(Vector2(30,30), Vector2(0,-12), Vector2(1,0.8))
		player.hit_box.set_export_values(500, 15, 1, 0.3, player.random_number, player.damage, player.knockback, player.stun)

func _on_animated_sprite_2d_animation_finished():
	if player.animated_sprite_2d.animation == "PlummetLand":
		landed.emit()

func _on_animated_sprite_2d_frame_changed():
	if player.animated_sprite_2d.animation == "PlummetLand" and player.animated_sprite_2d.frame >= 1 and player.input_axis:
		landed.emit()
