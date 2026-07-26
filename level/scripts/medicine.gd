extends Area2D

func _ready():
	body_entered.connect(entry)
	
func entry(body):
	if body.name!="Player" or !QuestManager.quests["medicine"]["started"]:
		return
	QuestManager.add_progress("medicine")
	print()
	
	queue_free()
