class_name stab_attack_state_musk1
extends State

signal idle

var musk1 : musk1
var extension: int = 16

func _ready():
	musk1 = get_tree().get_first_node_in_group("Boss")
	set_physics_process(false)
	
func _enter_state() -> void:
	musk1.current_animation_sprite = musk1.stab_attack;
	musk1.stab_attack.visible = true
	musk1.animation_player.play("Stab Attack")
	set_physics_process(true)

func _exit_state() -> void:
	musk1.current_animation_sprite.visible = false
	set_physics_process(false)

func _physics_process(delta):
	pass

func handle_stab():
	#Baseline is 113 pixels on x, 41 base compared to hitbox, 32 pixel half
	musk1.stab_extension.position.x = 113 + extension * 32
	musk1.stab_extension.scale.x = extension + 1
	
func handle_extension():
	musk1.hit_box_col.position.x = 41 + extension * 32
	musk1.hit_box_col.shape.size.x = 80 + extension * 64
	
func handle_state():
	musk1.attack_cd.start()
	musk1.movement_cd.start()
	idle.emit()
