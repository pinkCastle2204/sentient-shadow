extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	actor.deadboy()
	return SUCCESS
	
