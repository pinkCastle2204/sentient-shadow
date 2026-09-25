extends ActionLeaf
@export var patrol_distance: float = 100.0
@export var patrol_speed: float = 50.0
var start_position: Vector2
var moving_right: bool = true

func tick(actor: Node, _blackboard: Blackboard) -> int:
	if start_position == Vector2.ZERO:
		start_position = actor.global_position

	if moving_right:
		actor.velocity.x = patrol_speed
		if actor.global_position.x >= start_position.x + patrol_distance:
			moving_right = false
	else:
		actor.velocity.x = -patrol_speed
		if actor.global_position.x <= start_position.x - patrol_distance:
			moving_right = true
	if actor.isNear():
		return SUCCESS
	actor.face_direction(actor.velocity.x)
	actor.animated_sprite_2d.play("run")
	return RUNNING
