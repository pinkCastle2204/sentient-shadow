extends Node
class_name bod_state_machine

## State machine specific to the BringerOfDeath enemy.
## Expects exactly these four children under it, named exactly as below
## (matches your current scene tree):
##   Idle, chase, attack, patrol

enum StateId { IDLE, CHASE, ATTACK, PATROL }

@export var starting_state: StateId = StateId.PATROL
@export var debug_log: bool = true  # prints every transition to the Output panel

@onready var idle_state: state = $Idle
@onready var chase_state: state = $chase
@onready var attack_state: state = $attack
@onready var patrol_state: state = $patrol

var current_state: state
var current_state_id: StateId


func _ready() -> void:
	# Sanity-check the wiring up front instead of failing silently later.
	for n in [["Idle", idle_state], ["chase", chase_state], ["attack", attack_state], ["patrol", patrol_state]]:
		if n[1] == null:
			push_error("bod_state_machine: missing child node named '%s' (or it has no script extending `state`)" % n[0])

	for child in get_children():
		if child is state:
			child.change_state.connect(_on_child_change_state)

	_enter_state(starting_state)


func _on_child_change_state(new_state_name: String) -> void:
	match new_state_name:
		"Idle", "idle":
			_enter_state(StateId.IDLE)
		"chase":
			_enter_state(StateId.CHASE)
		"attack":
			_enter_state(StateId.ATTACK)
		"patrol":
			_enter_state(StateId.PATROL)
		_:
			push_warning("bod_state_machine: unknown state name '%s' — check the string a state script is emitting" % new_state_name)


func _enter_state(id: StateId) -> void:
	var next := _get_state_node(id)
	if next == null:
		push_error("bod_state_machine: state node for %s is null, can't enter it" % StateId.keys()[id])
		return

	if current_state == next:
		return

	if debug_log:
		print("[bod_state_machine] %s -> %s" % [
			StateId.keys()[current_state_id] if current_state else "none",
			StateId.keys()[id]
		])

	if current_state:
		current_state.exit()

	current_state = next
	current_state_id = id

	if current_state:
		current_state.enter()


func _get_state_node(id: StateId) -> state:
	match id:
		StateId.IDLE: return idle_state
		StateId.CHASE: return chase_state
		StateId.ATTACK: return attack_state
		StateId.PATROL: return patrol_state
	return null


func update(delta: float) -> void:
	if current_state:
		current_state.update(delta)


func physics_update(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)
