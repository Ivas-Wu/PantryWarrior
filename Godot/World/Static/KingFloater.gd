extends Path2D

@export var loop : bool = true
@export var speed : int = 1
@export var speed_scale : float = 1.0

@onready var path = $PathFollow2D
@onready var animation_player = $AnimationPlayer

func _ready():
	if not loop:
		animation_player.play("Move")
		animation_player.speed_scale = speed_scale
		set_process(false)

func _process(_delta):
	path.progress += speed
