extends state
 
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../../AnimatedSprite2D"

@onready var companion: CharacterBody2D = $"../../.."

 
func enter() -> void:
	print("chase: enter, target=", companion.target)
	animated_sprite_2d.play("run")
 
 
func update(_delta: float) -> void:
	if companion.target == null:
		change_state.emit("idle")
		return

	var distance : float = companion.distance_to_target()
	if distance > companion.lose_target_range:
		companion.target = null
		change_state.emit("idle")
		return

	if distance <= companion.attack_range:
		change_state.emit("attack")
		return

	var dir_x : float = companion.target.global_position.x - companion.global_position.x
	companion.velocity.x = signf(dir_x) * companion.chase_speed
	companion.set_facing(dir_x)
