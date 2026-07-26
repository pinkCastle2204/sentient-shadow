extends Area2D

var player_near =false

func _ready():
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)


func _process(_delta):
	if player_near and Input.is_action_just_pressed("interact"):
		talk()

func talk():
	var quest = QuestManager.quests["medicine"]

	#if quest not started
	if !quest["started"]:
		QuestManager.start_quest("medicine")
		print("Please collect 3 medicines for me.")	#this dialogue will be added in dialogue manager later on
		return

	# Quest in progress
	if !quest["completed"]:
		print("Medicines: %d/%d" % [
			quest["collected"],
			quest["required"]
		])
		return

	# Quest completed
	print("Thank you! You saved many lives.")	#this dialogue as well


func on_body_entered(body):
	if body.name == "Player":
		player_near = true

func on_body_exited(body):
	if body.name == "Player":
		player_near = false
