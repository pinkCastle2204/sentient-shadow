extends CharacterBody2D
class_name BringerOfDeath

# ---------------------------------------------------------------------------
# Animation names — edit these seven lines if your SpriteFrames resource
# names the animations differently than the crow_*.png files suggest.
# ---------------------------------------------------------------------------
const ANIM_IDLE   := "idle"
const ANIM_WALK    := "run"
const ANIM_JUMP    := "jump"      # used for the hop between patrol points
const ANIM_ATTACK  := "attack"
const ANIM_DAMAGE  := "damage"    # brief hit-reaction, doesn't change state
const ANIM_DEATHS  := ["death1"]  # one is picked at random

# ---------------------------------------------------------------------------
# Tuning
# ---------------------------------------------------------------------------
@export var move_speed: float = 40.0
@export var chase_speed: float = 75.0
@export var gravity: float = 980.0

@export var max_health: int = 100
@export var attack_damage: int = 15

@export var detection_range: float = 150.0   # how far it can "see" the player
@export var lose_target_range: float = 220.0 # gives up the chase past this
@export var attack_range: float = 30.0       # close enough to swing

## Points patrol.gd will walk between, in LOCAL space (relative to this node).
## Leave empty to just idle in place instead of patrolling.
@export var patrol_points: Array[Vector2] = [Vector2(925.0,340.0),Vector2(900.0,340.0),Vector2(1000.0,340.0)]

# The sprite art isn't symmetric, so flipping it with flip_h alone shifts the
# silhouette. Set these two offsets in the Inspector by eye (Play the scene,
# nudge AnimatedSprite2D.offset until the character reads correctly facing
# each way, then copy those numbers in here) and set_facing() will apply the
# right one automatically instead of you hand-flipping things at runtime.
@export var sprite_offset_right: Vector2 = Vector2.ZERO
@export var sprite_offset_left: Vector2 = Vector2.ZERO

# If your HitBox/HurtBox CollisionShape2D aren't perfectly centered on x=0,
# record their default (facing-right) local x position here so set_facing()
# can mirror it correctly instead of guessing.
@export var hit_box_offset_x: float = 0.0

# ---------------------------------------------------------------------------
# Node references - match the scene tree from bringer_of_death.tscn
# ---------------------------------------------------------------------------
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var fsm: bod_state_machine = $state_machineBOD
@onready var hit_box: HitBox = $HitBox
@onready var hurt_box: HurtBox = $HurtBox
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var collision_shape_2d: CollisionShape2D = $HitBox/CollisionShape2D

# ---------------------------------------------------------------------------
# Runtime state
# ---------------------------------------------------------------------------
var health: int
var facing: int = 1          # 1 = facing right, -1 = facing left
var target: Node2D = null    # currently the player, once spotted
var is_dead: bool = false
var is_flashing_damage: bool = false


func _ready() -> void:
	health = max_health
	hurt_box.damaged.connect(_on_hurt_box_damaged)
	hit_box.attacker = self
	hit_box.damage = attack_damage

	# NOTE: HitBox never listens for anything itself, so `monitoring` is
	# irrelevant here. What matters is `monitorable` — whether OTHER areas
	# (the player's HurtBox) can detect this one. That's the flag that needs
	# to be off outside of the attack swing.
	hit_box.monitorable = false  # only "live" while the attack state says so

	if hit_box_offset_x == 0.0:
		hit_box_offset_x = hit_box.position.x


func _physics_process(delta: float) -> void:
	if is_dead:
		return

	if not is_on_floor():
		velocity.y += gravity * delta

	fsm.update(delta)
	fsm.physics_update(delta)
	move_and_slide()
	progress_bar.value = health


# ---------------------------------------------------------------------------
# Facing / asymmetric sprite handling
# ---------------------------------------------------------------------------
## Call this from states instead of touching flip_h directly, so the
## asymmetric-sprite compensation always happens together with the flip.
func set_facing(direction: float) -> void:
	if direction == 0:
		return
	var dir: int = 1 if direction > 0 else -1
	if dir == facing:
		return

	facing = dir
	animated_sprite.flip_h = facing < 0
	animated_sprite.offset = sprite_offset_right if facing > 0 else sprite_offset_left

	hit_box.position.x = hit_box_offset_x if facing > 0 else -hit_box_offset_x
	hit_box.scale.x = 1 if facing > 0 else -1


# ---------------------------------------------------------------------------
# Player detection helper - used by idle/patrol/chase
# ---------------------------------------------------------------------------
func try_detect_player() -> bool:
	var player := get_tree().get_first_node_in_group("Player")
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


# ---------------------------------------------------------------------------
# Health / damage / death
# ---------------------------------------------------------------------------
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


## Plays the hit-reaction animation without changing what state we're in,
## then hands the animation back to whatever the current state wants to show.
func _flash_damage() -> void:
	if is_flashing_damage:
		return
	is_flashing_damage = true
	animated_sprite.play(ANIM_DAMAGE)
	await animated_sprite.animation_finished
	is_flashing_damage = false
	if not is_dead and fsm.current_state:
		fsm.current_state.enter()  # restores idle/walk/whatever was playing


func die() -> void:
	if is_dead:
		return
	is_dead = true
	velocity = Vector2.ZERO
	hurt_box.set_deferred("monitoring", false)   # stop US from detecting incoming hits
	hit_box.set_deferred("monitorable", false)   # stop OTHERS from detecting our hitbox
	animated_sprite.play(ANIM_DEATHS.pick_random())
	await animated_sprite.animation_finished
	queue_free()
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
	
