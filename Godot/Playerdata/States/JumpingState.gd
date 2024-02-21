class_name jump_state
extends State

signal falling
signal previous

var player : Player
var charge : float = 0

func _ready():
	set_physics_process(false)
	player = get_tree().get_first_node_in_group("Player")
	
func _enter_state() -> void:
	var can_jump = player.is_on_floor() or player.coyote_jump_timer.time_left > 0.0
	if can_jump:
		set_physics_process(true)
		player.animated_sprite_2d.play("JumpStart")
		if player.is_on_floor():
			if Input.is_action_pressed("Down") and player.skill_handler.agility > 0:
				player.velocity = Vector2.ZERO
			else:
				player.velocity.y = player.jump
		else:
			player.velocity.y = player.jump
	elif player.air_jump > 0:
		set_physics_process(true)
		player.air_jump -= 1
		player.velocity.y = player.jump * 0.7
	else:
		previous.emit()

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta):
	handle_jump(delta)
	handle_animation()
	handle_state_changes()
	player.move_and_slide()
	
func handle_jump(delta):
	if player.is_on_floor() and player.skill_handler.agility > 0:
		if Input.is_action_pressed("Down") and Input.is_action_pressed("Up"):
			player.velocity = Vector2.ZERO
			charge += delta
		if Input.is_action_just_released("Down"):
			player.velocity.y = player.jump * min(1 + charge, 1 + player.skill_handler.agility) + player.gravity * delta * 5
			charge = 0
	else:
		if Input.is_action_just_pressed("Up"):
			if player.air_jump > 0:
				player.air_jump -= 1
				player.velocity.y = player.jump * 0.7
		if Input.is_action_just_released("Up"):
			if player.velocity.y < player.jump/2:
				player.velocity.y = player.jump/2

func handle_animation():
	if player.is_on_floor():
		player.animated_sprite_2d.play("JumpStart")
	if not player.is_on_floor():
		player.animated_sprite_2d.play("JumpAirUp")

func handle_state_changes():
	if player.velocity.y > 0:
		handle_falling()

func handle_falling():
	falling.emit()
