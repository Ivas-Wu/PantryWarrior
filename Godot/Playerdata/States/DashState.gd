class_name dash_state
extends State

signal idle

var player : Player
var dir : int
var original_speed : int

func _ready():
	set_physics_process(false)
	player = get_tree().get_first_node_in_group("Player")
	
func _enter_state() -> void:
	dir = 1 if not player.animated_sprite_2d.flip_h else -1
	original_speed = player.velocity.x
	if player.skill_handler.defense == 5:
		player.hurt_box_col.disabled = true
	else:
		player.defense *= 1 + player.skill_handler.defense
	#reset properties to allow hit
	player.hit_box.already_hit = false
	player.hit_box_col.disabled = false
	player.hit_box_col.set_x_y_size(Vector2(20,20), Vector2(0,-8), Vector2(1,0.8))
	player.hit_box.set_export_values(100, 10, 1, 0, player.random_number, player.damage)
	player.animated_sprite_2d.play("Dash")
	set_physics_process(true)

func _exit_state() -> void:
	player.calculate_stats.calculate_defense()
	player.velocity.x = original_speed
	player.hurt_box_col.disabled = false
	player.hit_box_col.disabled = true
	set_physics_process(false)

func _physics_process(delta):
	player.velocity.x = dir * 200
	player.move_and_slide()

func _on_animated_sprite_2d_animation_finished():
	if player.animated_sprite_2d.animation == "Dash":
		idle.emit()
