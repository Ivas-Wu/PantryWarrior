class_name attack_state
extends State

signal previous
signal idle

var player : Player
var flip : bool = false

func _ready():
	set_physics_process(false)
	player = get_tree().get_first_node_in_group("Player")
	
func _enter_state() -> void:
	set_physics_process(true)
	flip = player.animated_sprite_2d.flip_h
	flip_scale()
	var attack = player.attack_queue[0]
	player.animated_sprite_2d.visible = false
	player.attack_animation.visible = true
	match attack:
		"Attack":
			player.animation_player.play("Basic_Attack")
		"BigAttack":
			player.animation_player.play("Big_Attack")
		"SpecialAttack":
			player.animation_player.play("Special_Attack")

func _exit_state() -> void:
	player.attack_queue.clear()
	player.animated_sprite_2d.visible = true
	player.attack_animation.visible = false
	player.animation_player.stop()
	player.hit_box.monitorable = false
	player.hit_box.monitoring = false
	flip_scale()
	set_physics_process(false)

func _physics_process(delta):
	player.velocity = Vector2.ZERO
	player.move_and_slide()

func flip_scale():
	if flip:
		player.scale.x *= -1
		
func _on_attacking_animation_player_animation_finished(anim_name):
	idle.emit()
