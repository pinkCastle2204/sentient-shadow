extends ActionLeaf
@export var chase_speed: float = 100.0

func tick(actor: Node, _blackboard: Blackboard) -> int:
	var boss = actor
	if boss.target == null:
		boss.velocity.x = 0
		return FAILURE

	if boss.isInAttackRange():
		boss.velocity.x = 0
		boss.animated_sprite_2d.play("idle")
		return SUCCESS

	var dir_x = boss.target.global_position.x - boss.global_position.x
	boss.face_direction(dir_x)

	if dir_x > 0:
		boss.velocity.x = chase_speed
	else:
		boss.velocity.x = -chase_speed

	boss.animated_sprite_2d.play("run")
	return RUNNING
