class_name EnemyHurtBox
extends Area2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var collision_polygon_2d = $CollisionPolygon2D

func _ready():
	collision_layer = 256
	collision_mask = 32
	if collision_polygon_2d:
		collision_polygon_2d.disabled = false
	else:
		collision_shape_2d.disabled = false

func _process(delta):
	pass
