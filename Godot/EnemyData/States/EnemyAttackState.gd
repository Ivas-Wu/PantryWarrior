class_name enemy_attack_state
extends State

var attacking: bool = false

signal aggro

@onready var actor = $"../.." as Enemy

func _ready():
	set_physics_process(false)
	
func _enter_state() -> void:
	actor.animated_sprite_2d.play("Attack")
	actor.enemy_hit_box.already_hit = false
	set_physics_process(true)

func _exit_state() -> void:
	actor.enemy_hit_box.monitoring = false
	actor.enemy_hit_box.monitorable = false
	actor.enemy_hit_box.visible = false
	set_physics_process(false)

func _physics_process(delta):
	actor.velocity = Vector2.ZERO
	actor.enemy_hit_box.position.x = 14 * actor.input_axis
	actor.move_and_slide()

func toggle_hitbox():
	actor.enemy_hit_box.monitoring = not actor.enemy_hit_box.monitoring
	actor.enemy_hit_box.monitorable = not actor.enemy_hit_box.monitorable
	actor.enemy_hit_box.visible = not actor.enemy_hit_box.visible

func _on_animated_sprite_2d_animation_finished():
	actor.attack_cd.start()
	aggro.emit()

func _on_animated_sprite_2d_frame_changed():
	if actor.animated_sprite_2d.get_animation() == "Attack" and (actor.animated_sprite_2d.get_frame() == 5 or actor.animated_sprite_2d.get_frame() == 4):
		toggle_hitbox()
