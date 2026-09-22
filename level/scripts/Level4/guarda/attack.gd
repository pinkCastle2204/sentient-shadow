extends state

@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var enemy: Guard = $"../.."
@onready var collision_shape_2d: CollisionShape2D = $"../../HitBox/CollisionShape2D"


func enter() -> void:
	enemy.velocity.x = 0.0
	animated_sprite_2d.play(enemy.ANIM_ATTACK)


func update(_delta: float) -> void:
	if not animated_sprite_2d.is_playing():
		if enemy.target == null:
			change_state.emit("patrol")
			return

		if enemy.distance_to_target() > enemy.attack_range:
			change_state.emit("chase")
			return

		animated_sprite_2d.play(enemy.ANIM_ATTACK)
		var dir_x: float = enemy.target.global_position.x - enemy.global_position.x

		
		enemy.set_facing(dir_x)

	


func _on_animated_sprite_2d_frame_changed() -> void:
	if animated_sprite_2d.animation != enemy.ANIM_ATTACK:
		collision_shape_2d.disabled = true
		return
	if animated_sprite_2d.frame == 1:
		collision_shape_2d.disabled = false
	else:
		collision_shape_2d.disabled = true
