extends ConditionLeaf




func tick(actor: Node, blackboard: Blackboard) -> int:
	if actor.talked:
		return FAILURE
	
	return SUCCESS
