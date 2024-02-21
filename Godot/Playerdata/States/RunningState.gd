class_name running_state
extends State

signal jump
signal idle
signal fall
signal roll

var player : Player

func _ready():
	set_physics_process(false)
	player = get_tree().get_first_node_in_group("Player")
	
func _enter_state() -> void:
	player.animated_sprite_2d.set_speed_scale((abs(player.velocity.x)+abs(player.velocity.x))/(player.speed+abs(player.velocity.x)))
	player.animated_sprite_2d.play("Running")
	set_physics_process(true)

func _exit_state() -> void:
	player.animated_sprite_2d.set_speed_scale(1)
	set_physics_process(false)

func _physics_process(delta):
	if player.input_axis == 0:
		idle.emit()
	else:
		handle_animation()
		handle_jump()
		handle_roll()
		var just_on_ground = player.is_on_floor()
		player.move_and_slide()
		if just_on_ground and not player.is_on_floor() and player.velocity.y >= 0:
			player.coyote_jump_timer.start()
			fall.emit()

func handle_animation():
	player.animated_sprite_2d.set_speed_scale((abs(player.velocity.x)+abs(player.velocity.x))/(player.speed+abs(player.velocity.x)))

func handle_jump():
	if Input.is_action_just_pressed("Up"):
		jump.emit()

func handle_roll():
	if Input.is_action_just_pressed("Roll"):
		roll.emit()
