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
	player.hurt_box_col.disabled = true
	player.animated_sprite_2d.play("Rolling")
	set_physics_process(true)

func _exit_state() -> void:
	player.velocity.x = original_speed
	player.hurt_box_col.disabled = false
	set_physics_process(false)

func _physics_process(delta):
	player.velocity.x = dir * 150
	player.move_and_slide()

func _on_animated_sprite_2d_animation_finished():
	if player.animated_sprite_2d.animation == "Rolling":
		idle.emit()
