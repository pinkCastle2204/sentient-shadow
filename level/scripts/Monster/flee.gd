extends state
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"

@onready var monster_2: CharacterBody2D = $"../.."

func enter():
	animated_sprite_2d.play("run")
	print("Flee state entered")

func update(delta: float):
	monster_2.flee()
	
func exit():
	pass
