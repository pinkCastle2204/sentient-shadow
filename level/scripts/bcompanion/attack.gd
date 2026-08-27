extends ActionLeaf
@onready var final_boss: CharacterBody2D = $"../../../.."
var attacks: Array = ["attack"]
var attackstr: String = ""

func tick(actor: Node, blackboard: Blackboard) -> int:
	if attackstr == "":
		attackstr = attacks[randi() % attacks.size()]
		actor.animated_sprite_2d.play(attackstr)
		return RUNNING

	if actor.animated_sprite_2d.is_playing():
		return RUNNING

	attackstr = ""  # reset so a new random attack is rolled next time
	return SUCCESS

func _on_animated_sprite_2d_frame_changed() -> void:
	var a: int
	var b: int
	if attackstr == "attack":
		a = 1
		b = 1
	elif attackstr == "attack2":
		a = 1
		b = 2
	elif attackstr == "attack3":
		a = 3
		b = 5
	if final_boss.animated_sprite_2d.animation != attackstr:
		final_boss.hitbox.disabled = true
	else:
		if final_boss.animated_sprite_2d.frame == a or final_boss.animated_sprite_2d.frame == b:
			final_boss.hitbox.disabled = false
		else:
			final_boss.hitbox.disabled = true
