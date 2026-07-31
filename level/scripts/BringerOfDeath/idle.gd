extends state

@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var enemy: BringerOfDeath = $"../.."

@export var idle_duration: float = 1.5  # how long to pause before resuming patrol

var idle_timer: float = 0.0


func enter() -> void:
	animated_sprite_2d.play(enemy.ANIM_IDLE)
	enemy.velocity.x = 0.0
	idle_timer = 0.0


func update(delta: float) -> void:
	if enemy.try_detect_player():
		change_state.emit("attack" if enemy.distance_to_target() <= enemy.attack_range else "chase")
		return

	idle_timer += delta
	if idle_timer >= idle_duration:
		if enemy.patrol_points.is_empty():
			idle_timer = 0.0  # nothing to patrol to, just keep idling
		else:
			change_state.emit("patrol")  # hand back to patrol for the next hop
