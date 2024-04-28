class_name running_state_musk1
extends State

signal jump
signal idle
signal basic
signal big
signal stab
signal dodge

var musk1 : musk1

func _ready():
	musk1 = get_tree().get_first_node_in_group("Boss")
	set_physics_process(false)
	
func _enter_state() -> void:
	# Add and check queued actions
	musk1.current_animation_sprite = musk1.running;
	musk1.running.visible = true
	musk1.animation_player.play("Running")
	set_physics_process(true)

func _exit_state() -> void:
	musk1.running.visible = false
	set_physics_process(false)

func _physics_process(delta):
	musk1.handle_enemy_finder()
	if musk1.handle_attack_range(basic, big, stab, dodge):
		if musk1.movement_update_buffer.time_left == 0 || musk1.navigation_agent_2d.is_target_reached():
			musk1.direction = get_direction()
			musk1.movement_update_buffer.start()
		musk1.move_and_slide()

func get_direction() -> Vector2:
	var dir : Vector2 = musk1.get_path_direction()
	return dir
