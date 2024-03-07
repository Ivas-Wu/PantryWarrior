class_name enemy_attack_state
extends State

var attacking: bool = false

signal aggro

@onready var actor = $"../.." as Enemy
	
func _ready():
	set_physics_process(false)
	
func _enter_state() -> void:
	actor.animated_sprite_2d.play("Attack")
	actor.hit_box.already_hit = false
	actor.hit_box.visible = true
	set_physics_process(true)

func _exit_state() -> void:
	actor.hit_box_col.disabled = true
	actor.animated_sprite_2d.stop()
	set_physics_process(false)

func _physics_process(delta):
	actor.velocity = Vector2.ZERO
	actor.hit_box.position.x = 14 * actor.input_axis
	actor.move_and_slide()

func _on_animated_sprite_2d_animation_finished():
	actor.attack_cd.start()
	aggro.emit()

func _on_animated_sprite_2d_frame_changed():
	if actor.animated_sprite_2d.get_animation() == "Attack" and actor.animated_sprite_2d.get_frame() == 5:
		actor.hit_box_col.disabled = false
	if actor.animated_sprite_2d.get_animation() == "Attack" and actor.animated_sprite_2d.get_frame() == 7:
		actor.hit_box_col.disabled = true
