extends ConditionLeaf
@onready var final_boss: CharacterBody2D = $"../../../.."


func tick(actor: Node, blackboard: Blackboard) -> int:
	if !actor.isNear():
		return SUCCESS
		
	return FAILURE
