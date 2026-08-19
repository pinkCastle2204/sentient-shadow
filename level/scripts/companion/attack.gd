extends state

@onready var animated_sprite_2d: AnimatedSprite2D = $"../../../AnimatedSprite2D"
@onready var collision_shape_2d: CollisionShape2D = $"../../../HitBox/CollisionShape2D"
@onready var hit_box: Area2D = $"../../../HitBox"
@onready var companion: CharacterBody2D = $"../../.."

# HitBox's distance from the companion's origin, captured once at startup
# (before we ever mirror it) so we always know how far out it should sit
# regardless of which way the companion is currently facing.
var hit_box_offset: float


func _ready() -> void:
	hit_box_offset = abs(hit_box.position.x)


func enter() -> void:

	animated_sprite_2d.frame_changed.connect(_on_animated_sprite_2d_frame_changed)
	companion.velocity.x = 0.0
	animated_sprite_2d.play("attack")
	var dir_x: float = companion.target.global_position.x - companion.global_position.x

	companion.set_facing(dir_x)
	# hit_box only does damage while we're mid-swing. `monitorable` (not
	# `monitoring`) is what lets the player's HurtBox detect this hit_box.
	companion.hit_box.set_deferred("monitorable", true)
	animated_sprite_2d.animation_finished.connect(_on_attack_finished, CONNECT_ONE_SHOT)


func update(_delta: float) -> void:
	companion.velocity.x = 0.0  # stand still for the whole swing


func exit() -> void:
	companion.hit_box.set_deferred("monitorable", false)
	if animated_sprite_2d.animation_finished.is_connected(_on_attack_finished):
		animated_sprite_2d.animation_finished.disconnect(_on_attack_finished)


func _face_target() -> void:
	if companion.target == null:
		return

	var dir_x: float = companion.target.global_position.x - companion.global_position.x
	companion.set_facing(dir_x)  # flips the sprite

	# Mirror the HitBox to the side the companion is now facing.
	


func _on_attack_finished() -> void:
	if companion.target == null:
		change_state.emit("idle")
		return

	if companion.distance_to_target() <= companion.attack_range:
		enter()  # same state, so re-trigger directly instead of change_state
				 # (state_machine no-ops when current_state == new_state)
	else:
		change_state.emit("chase")


func _on_animated_sprite_2d_frame_changed() -> void:
	if animated_sprite_2d.animation != "attack":
		collision_shape_2d.disabled = true
		return

	if animated_sprite_2d.frame == 3 or animated_sprite_2d.frame == 8:
		collision_shape_2d.disabled = false
	else:
		collision_shape_2d.disabled = true
