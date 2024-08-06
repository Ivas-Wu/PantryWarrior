class_name jump_state
extends State

signal falling
signal previous
signal plummet
signal landed

@onready var left = $"../../CharacterAttributes/left"
@onready var right = $"../../CharacterAttributes/right"
@onready var middleleft = $"../../CharacterAttributes/middleleft"
@onready var middleright = $"../../CharacterAttributes/middleright"

var charge : float = 0
var gravity : float = 1

func _enter_state() -> void:
	gravity = player.movement_data.gravity_scale
	set_physics_process(true)
	if Input.is_action_pressed("Up"):
		var can_jump = player.is_on_floor() or player.coyote_jump_timer.time_left > 0.0
		if can_jump:
			player.animated_sprite_2d.play("JumpStart")
			if player.is_on_floor():
				if Input.is_action_pressed("Down") and skills[skills_enum.CHARGED_JUMP]:
					player.velocity = Vector2.ZERO
				else:
					player.velocity.y += player.jump
			else:
				player.velocity.y += player.jump
		elif player.air_jump > 0:
			player.air_jump -= 1
			player.velocity.y = player.jump * 0.8
		else:
			previous.emit()

func _exit_state() -> void:
	player.movement_data.gravity_scale = gravity
	set_physics_process(false)

func _physics_process(delta):
	if player.is_on_floor()and Input.is_action_pressed("Down"):
		player.velocity.x = 0
	handle_jump(delta)
	handle_animation()
	handle_slide()
	handle_state_changes()
	player.move_and_slide()
	
func handle_jump(delta): #TODO add a pushed delay timer
	if player.is_on_floor() and skills[skills_enum.CHARGED_JUMP]:
		if Input.is_action_pressed("Down") and Input.is_action_pressed("Up"):
			player.velocity.x = 0
			charge += delta
		if Input.is_action_just_released("Down"):
			player.velocity.y = player.jump * min(1 + charge, 5)
			player.movement_data.gravity_scale = 1 + charge
			charge = 0
	else:
		if Input.is_action_just_pressed("Up"):
			if player.air_jump > 0:
				player.air_jump -= 1
				player.velocity.y = player.jump * 0.8
		if Input.is_action_just_released("Up"):
			if player.velocity.y < 0 :
				player.velocity.y /= 3
		player.handle_wall_jump()

func handle_animation():
	if player.wall_jump_flag:
		player.animated_sprite_2d.play("WallJump")
	else:
		if player.is_on_floor():
			player.animated_sprite_2d.play("JumpStart")
		if not player.is_on_floor():
			player.animated_sprite_2d.play("JumpAirUp")

func handle_state_changes():
	if Input.is_action_just_pressed("Down") and skills[skills_enum.PLUMMET]:
		plummet.emit()
	elif player.velocity.y > 0:
		falling.emit()
	elif player.animated_sprite_2d.animation == "JumpAirUp" and player.is_on_floor():
		landed.emit()

func handle_slide():
	if player.near_wall(): return
	var left_col = left.is_colliding()
	var middle_left_col = middleleft.is_colliding()
	var middle_right_col = middleright.is_colliding()
	var right_col = right.is_colliding()
	
	if left_col and not (right_col or middle_left_col or middle_right_col):
		player.position.x += 2
	elif right_col and not (left_col or middle_left_col or middle_right_col):
		player.position.x -= 2
