extends StaticBody2D

@export var length_scale : float = 1.0
@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D

func _ready():
	sprite_2d.scale.x *= length_scale
	collision_shape_2d.scale.x *= length_scale
