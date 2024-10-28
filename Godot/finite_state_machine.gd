class_name FiniteStateMachine
extends Node

@export var state : State
var previous_state : State = state

func _ready():
	pass
	
func change_state(new_state: State):
	if new_state == null: return
	if state is State:
		previous_state = state
		state._exit_state()
	state = new_state
	new_state._enter_state()
	

func change_to_previous_state():
	if state is State:
		state._exit_state()
	previous_state._enter_state()
	state = previous_state
