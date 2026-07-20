extends state
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"


@onready var monster_2: CharacterBody2D = $"../.."
@onready var player: CharacterBody2D = $"../../../Player"

func enter():
	animated_sprite_2d.play("run")

func update(delta: float):
	monster_2.chase()
	print("chase")

func exit():
	pass
