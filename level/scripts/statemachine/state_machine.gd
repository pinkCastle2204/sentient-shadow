extends Node
class_name state_machine

## Drag the default state node (e.g. "patrol" or "Idle") here in the Inspector.
@export var starting_state: state

var current_state: state

func _ready() -> void:
	# Auto-connect every child state's "change_state" signal so states never
	# need to know about each other or hold a reference to the machine.
	for child in get_children():
		if child is state:
			child.change_state.connect(_on_child_change_state)

	if starting_state:
		change_state(starting_state)

func change_state(new_state: state) -> void:
	if current_state == new_state:
		return

	if current_state:
		current_state.exit()

	current_state = new_state

	if current_state:
		current_state.enter()

func update(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func physics_update(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func _on_child_change_state(new_state_name: String) -> void:
	var target := get_node_or_null(new_state_name)
	if target and target is state:
		change_state(target)
	else:
		push_warning("state_machine: no state child named '%s'" % new_state_name)
