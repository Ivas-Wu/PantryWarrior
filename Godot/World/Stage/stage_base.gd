class_name stage_base
extends Node

@onready var player: Player = $Player
@export var crumb: Area2D = null

signal stage_complete()

func _ready():
	if crumb:
		crumb.complete.connect(complete_stage.bind())

func _process(delta):
	pass
	
func complete_stage(): 
	player.gain_exp(200) #need to make calculation here to balance this stat
	stage_complete.emit()
