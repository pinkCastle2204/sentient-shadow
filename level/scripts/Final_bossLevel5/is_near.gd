extends ConditionLeaf

func tick(actor: Node, blackboard: Blackboard) -> int:
	if actor.isInAttackRange():
		return SUCCESS
	return FAILURE
