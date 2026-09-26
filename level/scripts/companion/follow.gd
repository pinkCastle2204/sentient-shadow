extends state

@onready var animated_sprite_2d: AnimatedSprite2D = $"../../../AnimatedSprite2D"
@onready var companion: CharacterBody2D = $"../../.."

@export var interact_range: float = 40.0

func isNear() -> bool:
	return companion.distance_to_target() <= interact_range

func enter() -> void:
	animated_sprite_2d.play("run")

func update(delta: float):
	if isNear():
		change_state.emit("talk")
		return

	companion.move_toward_target(companion.move_speed)

func physics_update(_delta: float):
	pass

func exit():
	pass
