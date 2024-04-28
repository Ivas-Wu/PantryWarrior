class_name dodge_state_musk1
extends State

signal idle

var musk1 : musk1
var direction : int

func _ready():
	musk1 = get_tree().get_first_node_in_group("Boss")
	set_physics_process(false)
	
func _enter_state() -> void:
	# Add and check queued actions
	musk1.current_animation_sprite = musk1.dodge;
	#musk1.dodge.visible = true
	musk1.animation_player.play("Dodge")
	musk1.handle_enemy_finder()
	direction = -1 * musk1.enemy_finder_ray.target_position.x / abs(musk1.enemy_finder_ray.target_position.x)
	musk1.override_movement = true
	set_physics_process(true)

func _exit_state() -> void:
	#musk1.dodge.visible = false
	musk1.override_movement = false
	set_physics_process(false)

func _physics_process(delta):
	musk1.velocity.x = 250 * direction
	musk1.move_and_slide()
	
func jump():
	musk1.velocity.y = -100
	
func handle_state():
	idle.emit()
