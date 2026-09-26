extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	if actor.dead:
		return SUCCESS
	return FAILURE
