class_name spike_generator
extends Node2D

@export var count: int = 1
@export var offset: int = 16
var spikes = preload("res://Hazards/spikes.tscn")
@onready var location: Vector2 = global_position

func _ready():
	if count > 0:
		load_spikes()

func load_spikes():
	for c in range(count):
		var sp = spikes.instantiate()
		add_child(sp)
		sp.global_position = location
		location.x += offset
