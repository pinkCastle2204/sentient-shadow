extends state

@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var enemy: BringerOfDeath = $"../.."

@export var arrive_distance: float = 4.0

var patrol_index: int = 0
var origin: Vector2  # captured once, so patrol_points stay relative to spawn


func _ready() -> void:
	origin = enemy.global_position


func enter() -> void:
	animated_sprite_2d.play(enemy.ANIM_JUMP)  # crow hops rather than walks


func update(_delta: float) -> void:
	if enemy.try_detect_player():
		change_state.emit("attack" if enemy.distance_to_target() <= enemy.attack_range else "chase")
		return

	if enemy.patrol_points.is_empty():
		change_state.emit("Idle")
		return

	var target_point: Vector2 = origin + enemy.patrol_points[patrol_index]
	var dir_x := target_point.x - enemy.global_position.x

	if absf(dir_x) <= arrive_distance:
		enemy.velocity.x = 0.0
		patrol_index = (patrol_index + 1) % enemy.patrol_points.size()
		change_state.emit("Idle")  # let Idle handle the pause, then it hands back to us
		return

	enemy.velocity.x = signf(dir_x) * enemy.move_speed
	enemy.set_facing(dir_x)
