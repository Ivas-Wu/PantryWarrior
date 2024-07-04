class_name king_bounce_projectile
extends projectile_base

var max_bounce: int
var bounce_count : int = 0
@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("Spin")
	
func with_values(initial_velocity: Vector2 = Vector2(0,0), bounce: int = 0):
	set_velocity(initial_velocity)
	max_bounce = bounce
	return self

func _process(delta):
	generate_tween_shadow()
	if not is_on_floor():
		velocity.y += gravity * delta
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		if bounce_count == max_bounce:
			destroy()
		velocity = velocity.bounce(collision_info.get_normal()) * 0.7
		bounce_count += 1

func generate_tween_shadow():
	var shadow = $Sprite2D.duplicate()
	get_node("Shadow").add_child(shadow)

	shadow.global_position = global_position
	var tween = create_tween()

	shadow.modulate.v = 15
	shadow.z_index -= 1
	tween.tween_property(shadow, "modulate:a", 0, 0.1)
	tween.tween_callback(shadow.queue_free)
