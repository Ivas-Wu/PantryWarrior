class_name running_state
extends State

signal jump
signal idle
signal fall
signal roll
signal dash
signal attack 
signal up

func _enter_state() -> void:
	player.animated_sprite_2d.set_speed_scale((abs(player.velocity.x)+abs(player.velocity.x))/(player.speed+abs(player.velocity.x)))
	player.animated_sprite_2d.play("Running")
	set_physics_process(true)

func _exit_state() -> void:
	player.animated_sprite_2d.set_speed_scale(1)
	set_physics_process(false)

func _physics_process(delta):
	if not handle_state():
		handle_animation()
		var just_on_ground = player.is_on_floor()
		player.move_and_slide()
		if just_on_ground and not player.is_on_floor():
			if player.velocity.y >= 0:
				player.coyote_jump_timer.start()
				fall.emit()
			else:
				up.emit()

func handle_animation():
	player.animated_sprite_2d.set_speed_scale( max( (abs(player.velocity.x)+abs(player.velocity.x))/(player.speed+abs(player.velocity.x)), 1 if player.is_on_wall() else 0.5) )

func handle_state():
	if player.input_axis == 0:
		idle.emit()
	elif not player.attack_queue.is_empty():
		attack.emit()
	elif Input.is_action_just_pressed("Up"):
		jump.emit()
	elif Input.is_action_just_pressed("Roll") and skills[skills_enum.ROLL]:
		roll.emit()
	elif Input.is_action_just_pressed("Dash") and skills[skills_enum.DASH_ATTACK] and abs(player.velocity.x) > player.speed/2:
		dash.emit()
	else: return false
	return true
