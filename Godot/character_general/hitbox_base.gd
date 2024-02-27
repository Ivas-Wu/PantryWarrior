class_name hitbox_base
extends Area2D

@export var damage: int
@export var stun_time : float
@export var knock_back : float
@export var freeze_frames : float
@export var parent : base_character_class

var already_hit : bool = false;
var source : CollisionShape2D

func _ready():
	pass

func _process(delta):
	pass

func init():
	source = parent.character_collision_shape
	
func set_export_values(damage: int, knock: float, stun: float, freeze: float, rand: float, multiplier: float = 1) :
	generate_damage(damage * multiplier, rand)
	knock_back = knock * multiplier
	stun_time = stun * multiplier
	freeze_frames = freeze

func generate_damage(base_damage : float, rand: float):
	var variance = 0.75 + 0.5 * rand # 75% to 125% damage
	damage = base_damage * variance
