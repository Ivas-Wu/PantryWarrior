class_name walljump_state
extends State

signal falling
signal previous

func _enter_state() -> void:
	if skills[skills_enum.WALL_JUMP]:
		set_physics_process(true)
		player.velocity.x = -player.direction_to_wall() * 250
		player.velocity.y = -250
	else:
		previous.emit()

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta):
	player.animated_sprite_2d.play("WallJump")
	player.move_and_slide()
	
func _on_animated_sprite_2d_animation_finished():
	if player.animated_sprite_2d.animation == "WallJump":
		falling.emit() 
