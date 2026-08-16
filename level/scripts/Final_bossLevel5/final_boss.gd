extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hitbox: CollisionShape2D = $HitBox/CollisionShape2D

@export var talked: bool = false
@export var detectrange: float = 300.0
@export var attackrange: float = 30.0
@onready var target: CharacterBody2D = $"../Player"

@export var gravity: float = 980.0

var facing_right: bool = true

func face_direction(dir_x: float) -> void:
	if dir_x == 0:
		return
	var should_face_right = dir_x > 0
	if should_face_right == facing_right:
		return  # already facing that way, nothing to do

	facing_right = should_face_right
	animated_sprite_2d.flip_h = not facing_right

	# flip the hitbox to the other side
	hitbox.position.x = abs(hitbox.position.x) * (1 if facing_right else -1)
func isNear() -> bool:
	if target == null:
		print("❌ TARGET IS NULL")
		return false

	var distance_x = abs(target.global_position.x - global_position.x)

	print(
		"Boss X:", global_position.x,
		" | Target X:", target.global_position.x,
		" | Distance:", distance_x,
		" | Detect Range:", detectrange
	)

	return distance_x <= detectrange


func isInAttackRange() -> bool:
	if target == null:
		print("target not found")
		return false

	return abs(target.global_position.x - global_position.x) <= attackrange


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()
