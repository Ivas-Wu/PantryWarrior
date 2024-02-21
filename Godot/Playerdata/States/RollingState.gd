class_name rolling_state
extends State

signal idle
signal previous

var player : Player
var dir : int
var original_speed : int

func _ready():
	set_physics_process(false)
	player = get_tree().get_first_node_in_group("Player")
	
func _enter_state() -> void:
	if not player.is_on_floor(): previous.emit()
	else:
		dir = 1 if not player.animated_sprite_2d.flip_h else -1
		original_speed = player.velocity.x
		player.hurt_box.monitorable = false
		player.hurt_box.monitoring = false
		player.collision_mask = 7
		player.animated_sprite_2d.play("Rolling")
		set_physics_process(true)

func _exit_state() -> void:
	player.velocity.x = original_speed
	player.hurt_box.monitorable = true
	player.hurt_box.monitoring = true
	player.collision_mask = 23
	set_physics_process(false)

func _physics_process(delta):
	player.velocity.x = dir * 150
	player.move_and_slide()

func _on_animated_sprite_2d_animation_finished():
	idle.emit()
