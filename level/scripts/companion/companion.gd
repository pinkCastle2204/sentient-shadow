extends CharacterBody2D



# companion.gd — near your other @export vars
@export var target_group: String = "Enemy"
# ============================================================
# MOVEMENT
# ============================================================
@export var target: CharacterBody2D
@export var move_speed: float = 40.0
@export var chase_speed: float = 75.0
@export var gravity: float = 980.0
@onready var hit_box: HitBox = $HitBox

@export var detection_range: float = 150.0
@export var lose_target_range: float = 220.0
@export var attack_range: float = 30.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# ============================================================
# NODE REFERENCES
# ============================================================



@onready var fsm: Node = $state_machine


# ============================================================
# RUNTIME
# ============================================================

var facing: int = 1

var is_dead: bool = false


# ============================================================
# START
# ============================================================

func _ready() -> void:
	# The root HSM starts itself.
	# We don't need to manually choose Interact/Betray/Assist here.
	pass


# ============================================================
# PHYSICS
# ============================================================

func _physics_process(delta: float) -> void:
	
	if is_dead:
		return
	
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Let the HSM control the character
	if fsm != null:
		if fsm.has_method("update"):
			fsm.update(delta)

		if fsm.has_method("physics_update"):
			fsm.physics_update(delta)

	move_and_slide()
	

# ============================================================
# FACING
# ============================================================

func set_facing(dir_x: float) -> void:
	if dir_x == 0:
		return

	if dir_x > 0:
		animated_sprite.flip_h = false
		hit_box.position.x = abs(hit_box.position.x)
	else:
		animated_sprite.flip_h = true
		hit_box.position.x = -abs(hit_box.position.x)
		


# ============================================================
# PLAYER DETECTION
# ============================================================

# companion.gd — replace try_detect_player()
func try_detect_player() -> bool:
	var player := get_tree().get_first_node_in_group(target_group)
	if player == null:
		return false

	if global_position.distance_to(player.global_position) <= detection_range:
		target = player
		return true

	return false


func distance_to_target() -> float:
	if target == null:
		return INF

	return global_position.distance_to(target.global_position)


func has_target() -> bool:
	return target != null


func clear_target() -> void:
	target = null


# ============================================================
# MOVEMENT HELPERS
# ============================================================

func move_toward_target(speed: float) -> void:
	if target == null:
		velocity.x = 0
		animated_sprite.play("idle")
		return

	var direction := global_position.direction_to(target.global_position)
	velocity.x = direction.x * speed
	set_facing(direction.x)
	animated_sprite.play("run")


func stop() -> void:
	velocity.x = 0
	animated_sprite.play("idle")


func move_direction(direction: float, speed: float) -> void:
	velocity.x = direction * speed

	set_facing(direction)

	if direction != 0:
		animated_sprite.play("run")
	else:
		animated_sprite.play("idle")


# ============================================================
# JUMP
# ============================================================

func jump() -> void:
	velocity.y = -100


# ============================================================
# ATTACK
# ============================================================

func attack() -> void:
	velocity.x = 0
	animated_sprite.play("attack")


# ============================================================
# DEATH
# ============================================================

func die() -> void:
	if is_dead:
		return

	is_dead = true
	velocity = Vector2.ZERO

	animated_sprite.play("death1")

	await animated_sprite.animation_finished

	queue_free()
