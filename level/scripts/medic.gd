extends Area2D

var player_near =false
@onready var player: CharacterBody2D = $"../Player"
var talked = false
var op1 = false
var op2 = false
var op3 = false
var q1 = false
@onready var potion: Area2D = $"."

var item: InvItem
func _ready():
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)
	Dialogic.signal_event.connect(dialogic_signal)
	item = potion.item



func _process(_delta):
	if player_near and Input.is_action_just_pressed("interact"):
		if !talked:
			run_dialogue("FirstMedicMeet")
			talked = true
		elif op1:
			player.removeitems(item)
			run_dialogue("SecondMedicMeetFirstOption")
			personality.update_personality([50,-40,5,-10])
		elif op2:
			run_dialogue("SecondMedicSecondOption")
			personality.update_personality([-50,40,30,+30])
			
			
		elif op3:
			run_dialogue("SecondMedicThirdOption")
			personality.update_personality([0,0,-40,-20])
			
		
func run_dialogue(dia):
	player.player_inte = true
	Dialogic.start(dia)
	await Dialogic.timeline_ended
	player.player_inte = false
	
	
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
		
	else:
		q1 = true
		print("Thank you! You saved many lives.")	#this dialogue as well
		

	# Quest completed
func dialogic_signal(arg: String):
	if arg == "talk":
		op1 = true
		talk()
	elif arg == "option2":
		option2()
	elif arg == "option3":
		option3()
	
func option2():
	op2 = true
	talk()
func option3():
	op3 = true
func on_body_entered(body):
	if body.name == "Player":
		player_near = true

func on_body_exited(body):
	if body.name == "Player":
		player_near = false
