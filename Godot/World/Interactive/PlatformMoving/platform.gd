extends Path2D

@export var loop : bool = true
@export var speed : int = 1
@export var speed_scale : float = 1.0
@export var delay : int = 0

@onready var path = $PathFollow2D
@onready var animation_player = $AnimationPlayer
@onready var delay_timer = $Delay

func _ready():
	set_process(false)
	if delay > 0:
		delay_timer.wait_time = delay
		delay_timer.start()
		delay_timer.timeout.connect(init)
	else:
		init()
	
func init():
	if not loop:
		animation_player.play("Move")
		animation_player.speed_scale = speed_scale
	else:
		set_process(true)

func _process(_delta):
	path.progress += speed
