extends Area2D
@export var item : InvItem

func _ready():
	body_entered.connect(entry)
	
func entry(body):
	if body.name!="Player" or !QuestManager.quests["project_zero"]["started"]:
		return
	QuestManager.add_progress("project_zero")
	body.collect(item)
	print()
	
	queue_free()
