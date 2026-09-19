extends state

@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var enemy: BringerOfDeath = $"../.."
@onready var collision_shape_2d: CollisionShape2D = $"../../HitBox/CollisionShape2D"


# Start the attack swing
func enter() -> void:
	if not animated_sprite_2d.frame_changed.is_connected(_on_animated_sprite_2d_frame_changed):
		animated_sprite_2d.frame_changed.connect(_on_animated_sprite_2d_frame_changed)
	enemy.velocity.x = 0.0
	animated_sprite_2d.play(enemy.ANIM_ATTACK)
	animated_sprite_2d.animation_finished.connect(_on_attack_finished)


# Stop listening for frames and turn the hitbox back off
func exit() -> void:
	animated_sprite_2d.frame_changed.disconnect(_on_animated_sprite_2d_frame_changed)
	collision_shape_2d.disabled = true


# Stand still for the whole swing
func update(_delta: float) -> void:
	enemy.velocity.x = 0.0


# Decide what to do once the attack animation ends
func _on_attack_finished() -> void:
	print("attack finished")
	if enemy.target == null:
		change_state.emit("patrol")
		return
	if enemy.distance_to_target() <= enemy.attack_range:
		enter()  # still in range, re-trigger the same state directly
		print("Repeated once again")
	else:
		change_state.emit("chase")


# Only let the hitbox land on the swing frame
func _on_animated_sprite_2d_frame_changed() -> void:
	if animated_sprite_2d.animation != enemy.ANIM_ATTACK:
		collision_shape_2d.disabled = true
		return
	if animated_sprite_2d.frame == 1:
		collision_shape_2d.disabled = false
	else:
		collision_shape_2d.disabled = true
