class_name hitbox_collision_shape_base
extends CollisionShape2D

func _ready():
	pass

func _process(delta):
	pass

func set_x_y_size(size: Vector2, pos: Vector2, sca: Vector2):
	shape.size = size
	position = pos
	scale = sca
