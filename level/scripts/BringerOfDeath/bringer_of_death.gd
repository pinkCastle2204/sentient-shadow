extends CharacterBody2D
class_name BringerOfDeath

# Animation names, change if your SpriteFrames uses different names
const ANIM_IDLE   := "idle"
const ANIM_WALK    := "run"
const ANIM_JUMP    := "jump"
const ANIM_ATTACK  := "attack"
const ANIM_DAMAGE  := "damage"
const ANIM_DEATHS  := ["death1"]


@export var move_speed: float = 40.0
@export var chase_speed: float = 75.0
@export var gravity: float = 980.0

@export var max_health: int = 100
@export var attack_damage: int = 15

@export var detection_range: float = 150.0
@export var lose_target_range: float = 220.0
@export var attack_range: float = 30.0

# Patrol points in local space, leave empty to idle in place
@export var patrol_points: Array[Vector2] = [Vector2(925.0,340.0),Vector2(900.0,340.0),Vector2(1000.0,340.0)]

# Default x position of the hit box when facing right
@export var hit_box_shift_x: float = 0.0

# Node references, must match bringer_of_death.tscn
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var fsm: bod_state_machine = $state_machineBOD
@onready var hit_box: HitBox = $HitBox
@onready var hurt_box: HurtBox = $HurtBox
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var collision_shape_2d: CollisionShape2D = $HitBox/CollisionShape2D

# Runtime state
var health: int
var facing: int = 1
var target: Node2D = null
var is_dead: bool = false
var is_flashing_damage: bool = false


func _ready() -> void:
	health = max_health
	hurt_box.damaged.connect(_on_hurt_box_damaged)
	hit_box.attacker = self
	hit_box.damage = attack_damage

	

	


func _physics_process(delta: float) -> void:
	if is_dead:
		return

	if not is_on_floor():
		velocity.y += gravity * delta

	fsm.update(delta)
	fsm.physics_update(delta)
	move_and_slide()
	progress_bar.value = health


# Flip sprite and mirror the hit box to match facing direction
func set_facing(direction: float) -> void:
	if direction == 0:
		return
	var dir: int = 1 if direction > 0 else -1
	if dir == facing:
		return

	facing = dir
	animated_sprite.flip_h = facing < 0

	hit_box.position.x = hit_box_shift_x if facing > 0 else -hit_box_shift_x
	hit_box.scale.x = 1 if facing > 0 else -1


# Look for the player within detection range
func try_detect_player() -> bool:
	var player := get_tree().get_first_node_in_group("Player")
	if player == null:
		return false
	if global_position.distance_to(player.global_position) <= detection_range:
		target = player
		return true
	return false


# Distance to the current target, or infinite if none
func distance_to_target() -> float:
	if target == null:
		return INF
	return global_position.distance_to(target.global_position)


func _on_hurt_box_damaged(hitbox: HitBox) -> void:
	take_damage(hitbox.damage)


func take_damage(amount: int) -> void:
	if is_dead:
		return
	health = max(health - amount, 0)
	if health == 0:
		die()
	else:
		_flash_damage()


# Play the hit reaction, then resume whatever state was already playing
func _flash_damage() -> void:
	if is_flashing_damage:
		return
	is_flashing_damage = true
	animated_sprite.play(ANIM_DAMAGE)
	await animated_sprite.animation_finished
	is_flashing_damage = false
	if not is_dead and fsm.current_state:
		fsm.current_state.enter()


func die() -> void:
	if is_dead:
		return
	is_dead = true
	progress_bar.visible = false
	velocity = Vector2.ZERO
	
	animated_sprite.play(ANIM_DEATHS.pick_random())
	await animated_sprite.animation_finished
	queue_free()


# Only allow hits to land on frame 3 of the attack animation
func _on_animated_sprite_2d_frame_changed() -> void:
	if animated_sprite.animation != "attack":
		collision_shape_2d.disabled = true
		return

	if animated_sprite.frame == 3:
		collision_shape_2d.disabled = false
	else:
		collision_shape_2d.disabled = true


func jump():
	velocity.y = -100
