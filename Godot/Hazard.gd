class_name Hazard
extends Area2D

@export var damage: int
@export var knock_back : int
@onready var source_location = $SourceLocation

var source : Vector2

func _ready():
	collision_layer = 4
	collision_mask = 2
	source = source_location.global_position

func _process(delta):
	pass
