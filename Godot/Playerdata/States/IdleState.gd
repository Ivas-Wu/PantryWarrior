class_name idle_state
extends State

signal jump
signal run
signal fall
signal roll
signal attack
signal up

var player : Player

func _ready():
	set_physics_process(false)
	player = get_tree().get_first_node_in_group("Player")
	
func _enter_state() -> void:
	# Add and check queued actions
	player.animated_sprite_2d.play("Idle")
	set_physics_process(true)

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta):
	if not handle_state():
		var just_on_ground = player.is_on_floor()
		player.move_and_slide()
		if just_on_ground and not player.is_on_floor():
			if player.velocity.y >= 0:
				player.coyote_jump_timer.start()
				fall.emit()
			else:
				up.emit()

func handle_state():
	var sig = false
	if not player.attack_queue.is_empty():
		attack.emit()
		sig = true
	elif Input.is_action_just_pressed("Up"):
		jump.emit()
		sig = true
	elif Input.is_action_just_pressed("Roll"):
		roll.emit()
		sig = true
	elif player.input_axis:
		run.emit()
		sig = true
	return sig
