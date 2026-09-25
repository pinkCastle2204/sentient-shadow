extends ActionLeaf

var dialogue_started := false


func tick(actor: Node, _blackboard: Blackboard) -> int:

	if not dialogue_started:
		
		actor.target.velocity = Vector2(0,0)
		var boss = actor
		var dir_x = boss.target.global_position.x - boss.global_position.x
		boss.face_direction(dir_x)
		actor.animated_sprite_2d.play("idle")
		actor.velocity.x = 0
		boss.target.player_inte = true
		Dialogic.start("Unit7first")
		dialogue_started = true

		return RUNNING


	if Dialogic.current_timeline != null:
		return RUNNING


	dialogue_started = false
	actor.talked = true
	actor.target.player_inte = false
	actor.animated_sprite_2d.visible = false
	actor.collision_shape_2d.disabled = true
	
	return SUCCESS
