extends ActionLeaf

@onready var final_boss: CharacterBody2D = $"../../../.."

var attackstr: String = ""

func tick(actor: Node, blackboard: Blackboard) -> int:
	if attackstr == "":
		attackstr = "attack"
		actor.animated_sprite_2d.play(attackstr)
		return RUNNING

	if actor.animated_sprite_2d.is_playing():
		return RUNNING

	attackstr = ""
	final_boss.hitbox.disabled = true
	return SUCCESS


func _on_animated_sprite_2d_frame_changed() -> void:
	if final_boss.animated_sprite_2d.animation != "attack":
		final_boss.hitbox.disabled = true
		return

	# Enable hitbox only on the 3rd and 8th frames.
	if final_boss.animated_sprite_2d.frame == 3 \
	or final_boss.animated_sprite_2d.frame == 8:
		final_boss.hitbox.disabled = false
	else:
		final_boss.hitbox.disabled = true
