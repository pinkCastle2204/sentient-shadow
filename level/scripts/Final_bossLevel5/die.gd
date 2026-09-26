extends ActionLeaf

var death_started := false

func _enter() -> void:
	death_started = false

func tick(actor: Node, blackboard: Blackboard) -> int:
	actor.dead = true
	actor.final_bosshealth.visible = false

	if not death_started:
		death_started = true
		actor.animated_sprite_2d.play("death")

		return RUNNING

	if actor.animated_sprite_2d.animation != "death":
		return RUNNING

	if actor.animated_sprite_2d.is_playing():
		return RUNNING

	actor.queue_free()
	return SUCCESS
