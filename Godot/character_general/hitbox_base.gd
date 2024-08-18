class_name hitbox_base
extends Area2D

@export var damage: int
@export var stun_time : float
@export var knock_back : float
@export var freeze_frames : float

# if it is a character the parent will be passed in, it is a base_character_class
# and will have everything required for the source
# if it is a projectile, the parent will be passed in soley to destroy the projectile after
# you will need to pass in a source col shape/polygon as well
@export var parent : CharacterBody2D
@export var source_col_shape : CollisionShape2D
@export var source_col_polygon : CollisionPolygon2D

var already_hit : bool = false;
var source

func _ready():
	pass

func _process(delta):
	pass

func init():
	if source_col_shape:
		source = source_col_shape
	elif source_col_polygon:
		source = source_col_polygon
	else:
		source = parent.character_collision_polygon
	
func set_export_values(dmg: int, knock: float, stun: float, freeze: float, rand: float, multiplier: float = 1, km: float = 1, sm: float = 1) :
	generate_damage(dmg * multiplier, rand)
	knock_back = knock * km
	stun_time = stun * sm
	freeze_frames = freeze

func generate_damage(base_damage : float, rand: float):
	var variance = 0.75 + 0.5 * rand # 75% to 125% damage
	damage = base_damage * variance
