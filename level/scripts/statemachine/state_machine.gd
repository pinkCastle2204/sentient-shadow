extends Node
class_name state_machine
var current_state : state

func change_state(new_state : state):
	if current_state == new_state:
		return

	if current_state:
		current_state.exit()

	current_state = new_state

	if current_state:
		current_state.enter()

func update(delta):
	if current_state:
		current_state.update(delta)
