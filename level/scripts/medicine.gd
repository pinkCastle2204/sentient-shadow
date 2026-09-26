extends Area2D
@export var item : InvItem
func _ready():
	body_entered.connect(entry)
	
func entry(body):
	if body.name!="Player" or !QuestManager.quests["medicine"]["started"]:
		return
	QuestManager.add_progress("medicine")
	body.collect(item)
	print()
	
	queue_free()
