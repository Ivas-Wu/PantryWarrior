class_name running_state_musk1
extends State

signal jump
signal idle
signal basic
signal big
signal stab

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
	if handle_attack_range():
		if musk1.movement_update_buffer.time_left == 0 || musk1.navigation_agent_2d.is_target_reached():
			musk1.direction = get_direction()
			musk1.movement_update_buffer.start()
		musk1.move_and_slide()

func get_direction() -> Vector2:
	var dir : Vector2 = musk1.get_path_direction()
	return dir
		
func handle_attack_range() -> bool:
	var big_range = musk1.handle_big_attack_ray()
	var small_range = musk1.handle_small_attack_ray()

	if musk1.attack_cd.time_left > 0:
		return true
	if not big_range:
		if musk1.random_number > 0.995:
			stab.emit()
		else:
			return true
	elif small_range: #range of both
		if musk1.random_number > 0.2:
			basic.emit()
	else: #big attack range only
		#moving away
		if musk1.player.velocity.x * musk1.enemy_finder_ray.target_position.x < 0:
			if musk1.random_number > 0.85:
				big.emit()
		#moving towards
		else:
			if musk1.random_number > 0.5:
				big.emit()
	return false
