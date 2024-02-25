class_name falling_state
extends State

signal landed
signal previous
signal jump
signal plummet

var player : Player

func _ready():
	set_physics_process(false)
	player = get_tree().get_first_node_in_group("Player")
	
func _enter_state() -> void:
	if player.is_on_floor(): landed.emit()
	else:
		player.animated_sprite_2d.play("JumpAirDown")
		set_physics_process(true)

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta):
	if Input.is_action_just_pressed("Up"):
		jump.emit()
	elif Input.is_action_just_pressed("Down") and player.skill_handler.special > 0:
		plummet.emit()
	else:
		var in_air = not player.is_on_floor()
		player.velocity.y += player.gravity * delta * 1.1
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
