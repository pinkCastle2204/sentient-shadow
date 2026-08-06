extends Node

@onready var utility_brain: Node = $"../UtilityBrain"
@onready var chase: state = $chase
@onready var patrol: state = $patrol
@onready var attack: state = $attack
@onready var flee: state = $flee

@export var current_state = patrol
@export var chase_state= chase
@export var flee_state= flee
@export var attack_state= attack
@export var patrol_state= patrol
func _process(delta: float) -> void:
	match utility_brain.curr:
			"patrol":
				change_state(patrol)
			"chase":
				change_state(chase)
			"attack":
				change_state(attack)
					
			"flee":
				change_state(flee)
			
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
