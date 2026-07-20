extends state
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var collision_shape_2d: CollisionShape2D = $"../../AttackArea/CollisionShape2D"
@onready var collision_shape_2d_2: CollisionShape2D = $"../../AttackArea/CollisionShape2D2"


@onready var monster_2: CharacterBody2D = $"../.."
@onready var player: CharacterBody2D = $"../../../Player"

func enter():
	animated_sprite_2d.play("attack")

func update(delta: float):
	monster_2.attack()
	print("attack")

func exit():
	collision_shape_2d.disabled = true
	collision_shape_2d_2.disabled = true
