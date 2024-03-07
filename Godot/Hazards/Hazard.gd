class_name Hazard
extends Area2D

@export var damage: int = 0
@export var knock_back : int = 0

@onready var source_location = $SourceLocation

var source : Vector2

func _ready():
	collision_layer = 4
	collision_mask = 2
	source = source_location.global_position

func _process(delta):
	pass
