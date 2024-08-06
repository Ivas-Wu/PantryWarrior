class_name idle_state
extends State

signal jump
signal run
signal fall
signal roll
signal attack
signal up
	
func _enter_state() -> void:
	# Add and check queued actions
	player.animated_sprite_2d.play("Idle")
	set_physics_process(true)

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta):
	if not handle_state():
		var just_on_ground = player.is_on_floor()
		player.move_and_slide()
		if just_on_ground and not player.is_on_floor():
			if player.velocity.y >= 0:
				player.coyote_jump_timer.start()
				fall.emit()
			else:
				up.emit()

func handle_state():
	if not player.attack_queue.is_empty():
		attack.emit()
	elif Input.is_action_just_pressed("Up"):
		jump.emit()
	elif Input.is_action_just_pressed("Roll") and skills[skills_enum.ROLL]:
		roll.emit()
	elif player.input_axis:
		run.emit()
	else: return false
	return true
