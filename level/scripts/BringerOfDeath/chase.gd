extends state
 
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var enemy: BringerOfDeath = $"../.."
 
 
func enter() -> void:
	animated_sprite_2d.play(enemy.ANIM_WALK)
 
 
func update(_delta: float) -> void:
	if enemy.target == null:
		change_state.emit("patrol")
		return
 
	var distance := enemy.distance_to_target()
 
	if distance > enemy.lose_target_range:
		enemy.target = null
		change_state.emit("patrol")
		return
 
	if distance <= enemy.attack_range:
		change_state.emit("attack")
		return
 
	var dir_x := enemy.target.global_position.x - enemy.global_position.x
	enemy.velocity.x = signf(dir_x) * enemy.chase_speed
	enemy.set_facing(dir_x)
 
