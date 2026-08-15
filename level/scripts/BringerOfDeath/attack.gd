extends state

@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var enemy: BringerOfDeath = $"../.."
@onready var collision_shape_2d: CollisionShape2D = $"../../HitBox/CollisionShape2D"


func enter() -> void:
	animated_sprite_2d.frame_changed.connect(_on_animated_sprite_2d_frame_changed)
	enemy.velocity.x = 0.0
	animated_sprite_2d.play(enemy.ANIM_ATTACK)
	# Hitbox only does damage while we're mid-swing. `monitorable` (not
	# `monitoring`) is what lets the player's HurtBox detect this HitBox.
	enemy.hit_box.set_deferred("monitorable", true)
	animated_sprite_2d.animation_finished.connect(_on_attack_finished, CONNECT_ONE_SHOT)


func update(_delta: float) -> void:
	enemy.velocity.x = 0.0  # stand still for the whole swing


func exit() -> void:
	enemy.hit_box.set_deferred("monitorable", false)
	if animated_sprite_2d.animation_finished.is_connected(_on_attack_finished):
		animated_sprite_2d.animation_finished.disconnect(_on_attack_finished)


func _on_attack_finished() -> void:
	if enemy.target == null:
		change_state.emit("patrol")
		return

	if enemy.distance_to_target() <= enemy.attack_range:
		enter()  # same state, so re-trigger directly instead of change_state
				 # (state_machine no-ops when current_state == new_state)
	else:
		change_state.emit("chase")

func _on_animated_sprite_2d_frame_changed() -> void:
	if animated_sprite_2d.animation != enemy.ANIM_ATTACK:
		collision_shape_2d.disabled = true
		
		return

	if animated_sprite_2d.frame == 1:
		collision_shape_2d.disabled = false
	else:
		collision_shape_2d.disabled = true
