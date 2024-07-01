class_name king_bounce_projectile
extends projectile_base

var max_bounce: int
var bounce_count : int = 0

func _ready():
	pass
	
func with_values(initial_velocity: Vector2 = Vector2(0,0), bounce: int = 0):
	set_velocity(initial_velocity)
	max_bounce = bounce
	return self

func _process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		if bounce_count == max_bounce:
			destroy()
		velocity = velocity.bounce(collision_info.get_normal()) * 0.9
		bounce_count += 1
