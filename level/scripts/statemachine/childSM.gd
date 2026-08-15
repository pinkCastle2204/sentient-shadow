class_name ChildStateMachine
extends state


@export var initial_state: state
@export var target_group: String = ""  # leave blank on branches that don't need to change it

var current_state: state

# childSM.gd
func enter() -> void:
	if target_group != "":
		var comp = get_node("../..")
		comp.target_group = target_group
		comp.target = null                       # force re-detection under the new group
		print(name, " set target_group to: ", target_group)

	if initial_state == null:
		push_error(name + ": No initial state assigned")
		return
	_set_state(initial_state)


func _ready() -> void:
	for child in get_children():
		if child is state:
			child.change_state.connect(_on_child_change_state)



func update(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func physics_update(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func _set_state(new_state: state) -> void:
	if current_state == new_state:
		return
	if current_state:
		current_state.exit()
	current_state = new_state
	if current_state:
		current_state.enter()

func exit() -> void:
	if current_state:
		current_state.exit()
	current_state = null

func _on_child_change_state(new_state_name: String) -> void:
	var target := get_node_or_null(new_state_name)
	if target and target is state:
		_set_state(target)
	else:
		push_warning(name + ": no state child named '%s'" % new_state_name)
