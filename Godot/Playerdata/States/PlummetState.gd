class_name plummet_state
extends State

signal landed
signal previous
signal jump
signal fall

var player : Player

func _ready():
	set_physics_process(false)
	player = get_tree().get_first_node_in_group("Player")
	
func _enter_state() -> void:
	if player.is_on_floor(): landed.emit()
	else:
		player.animated_sprite_2d.play("PlummetFall")
		player.velocity.y += 300
		player.hit_box_col.shape.size.x = 5
		player.hit_box_col.shape.size.y = 2.5
		player.hit_box_col.position.x = 0.5
		player.hit_box_col.position.y = -1.25
		player.hit_box_col.scale.x = 2
		player.hit_box_col.scale.y = 2
		player.hit_box_col.disabled = false
		player.hit_box.damage = 100
		player.hit_box.knock_back = 300
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
	if Input.is_action_just_pressed("Up"):
		jump.emit()
	elif Input.is_action_just_released("Down"):
		fall.emit()
	else:
		var in_air = not player.is_on_floor()
		player.move_and_slide()
		if in_air and player.is_on_floor():
			handle_landing()

func handle_landing():
	player.animated_sprite_2d.play("PlummetLand")

func _on_animated_sprite_2d_animation_finished():
	if player.animated_sprite_2d.animation == "PlummetLand":
		landed.emit()

func _on_animated_sprite_2d_frame_changed():
	if player.animated_sprite_2d.animation == "PlummetLand" and player.animated_sprite_2d.frame >= 1 and player.input_axis:
		landed.emit()
