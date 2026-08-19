extends ConditionLeaf


func tick(actor: Node, _blackboard: Blackboard) -> int:
	print("isNear CONDITION - actor: ", actor.name)

	if actor.isNear():
		print("✅ isNear SUCCESS")
		return SUCCESS

	print("❌ isNear FAILURE")
	return FAILURE
