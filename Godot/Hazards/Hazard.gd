class_name Hazard
extends Area2D

@export var damage: int = 0
@export var knock_back : int = 0

@onready var source = $SourceLocation

func _ready():
	collision_layer = 4
	collision_mask = 2

func _process(delta):
	pass
