extends state

@onready var companion: CharacterBody2D = $"../../.."
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../../AnimatedSprite2D"
# companion.gd — near your other @export vars




func enter() -> void:
	animated_sprite_2d.play("idle")
	companion.velocity.x = 0.0


func update(delta: float) -> void:
	if companion.try_detect_player():
		print("idle: detected player, target=", companion.target)
		change_state.emit("attack" if companion.distance_to_target() <= companion.attack_range else "chase")
		return
