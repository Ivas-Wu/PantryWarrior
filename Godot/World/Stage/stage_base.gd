class_name stage_base
extends Node

@onready var player: Player = $Player/Player
@onready var crumb: Area2D = $Collectibles/Crumb

func _ready():
	crumb.complete.connect(complete_stage.bind())

func _process(delta):
	pass
	
func complete_stage(): 
	player.gain_exp(200) #need to make calculation here to balance this stat
