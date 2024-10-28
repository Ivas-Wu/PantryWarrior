class_name falling_state
extends State

signal landed
signal previous
signal jump
signal plummet
signal wall

func _enter_state() -> void:
	if player.is_on_floor(): landed.emit()
	else:
		player.animated_sprite_2d.play("JumpAirDown")
		set_physics_process(true)

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta):
	if player.is_on_floor(): #sanity check
		landed.emit()
	if check_jump():
		jump.emit()
	elif check_plummet():
		plummet.emit()
	else:
		var in_air = not player.is_on_floor()
		if in_air: 
			if handle_wall_jump():
				wall.emit()
		player.velocity.y += player.gravity * delta * 1.07
		player.move_and_slide()
		if in_air and player.is_on_floor():
			handle_landing()

func handle_landing():
	player.animated_sprite_2d.play("JumpEnd")

func _on_animated_sprite_2d_animation_finished():
	if player.animated_sprite_2d.animation == "JumpEnd":
		landed.emit()

func _on_animated_sprite_2d_frame_changed():
	if player.animated_sprite_2d.animation == "JumpEnd" and player.animated_sprite_2d.frame >= 1 and player.input_axis:
		landed.emit()
