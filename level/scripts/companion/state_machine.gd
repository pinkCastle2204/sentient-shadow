
extends Node



@onready var interact: Node = $Interact
@onready var betray: Node = $Betray
@onready var assist: Node = $Assist

var current_state_machine: Node


func _ready() -> void:
	start()


func start() -> void:
	if personality.best_name == null:
		push_error("StateMachine: Personality is not assigned.")
		return

	personality.classify_personality()

	var personality_name = personality.best_name

	print("Personality: ", personality_name)

	match personality_name:
		"Selfish":
			change_state(betray)

		"Empathy":
			change_state(assist)

		"Aggressive":
			change_state(betray)

		"Brave":
			change_state(assist)

		_:
			change_state(interact)


func change_state(new_state: Node) -> void:
	if current_state_machine == new_state:
		return

	if current_state_machine != null:
		current_state_machine.exit()

	current_state_machine = new_state

	print("HSM -> ", current_state_machine.name)

	current_state_machine.enter()
func update(delta: float) -> void:
	if current_state_machine and current_state_machine.has_method("update"):
		current_state_machine.update(delta)

func physics_update(delta: float) -> void:
	if current_state_machine and current_state_machine.has_method("physics_update"):
		current_state_machine.physics_update(delta)
