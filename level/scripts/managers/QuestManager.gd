extends Node

signal quest_started(id)
signal quest_updated(id)
signal quest_completed(id)
signal quest_completed2(id)

var dead_signal_route := ""

func set_route(route: String):
	dead_signal_route = route
	print("Dead Signal route: ", route)


var quests = {}				#initially empty, will be filled upon adding quests

func _ready():
	register_quest(
		"medicine",
		"Find Medicines",
		"Collect 3 medicines for the medic",
		3,
		"Return to the medic"
	)
	register_quest(
		"project_zero",
		"Recover Project Zero Records",
		"Find 3 Project Zero records",
		3,
		"Find terminal to place the records"
	)

	register_quest(
		"rescue_child",
		"Rescue the Child",
		"Rescue the trapped child",
		1,
		"Go to the refugee"
	)
	register_quest(
		"dead_signal",
		"Repair the Radio Tower",
		"Climb the Radio Tower and fix the Transmitter",
		1,
		"Return"		
	)
	register_quest(
		"guard",
		"Make way somehow to enter laboratory",
		"Player has to enter the lab where he will face GUARD",
		1,
		"Well done"
	)
	register_quest(
		"computer",
		"Access the hidden file in computer",
		"Player has to access the hidden file in computer ",
		1,
		"File access completed"
	)
	#Add more quests here

#Add quests into the dictionary using this function
func register_quest(id:String, title:String, description:String,required:int,text:String):
	quests[id] = {
		"title": title,
		"description": description,
		"started": false,
		"completed": false,
		"completed2": false,	#this is for quests which have 2 phases
		"collected": 0,
		"required": required,
		"text_upon_completion": text,
	}
	
	
func start_quest(id:String):
	if !quests.has(id):
		return				#To prevent crashes if quest doesnt exist
	
	if quests[id]["started"]:
		return				#To prevent a quest from restarting
	
	quests[id]["started"]=true;
	
	quest_started.emit(id);		#emit signal that quest has started
	
func add_progress(id:String, amt:=1):
	if !quests.has(id):
		return
	
	if !quests[id]["started"]:
		return
		
	if quests[id]["completed"]:
		return
		
	quests[id]["collected"] +=amt
	
	if quests[id]["collected"]>=quests[id]["required"]:	#if requirements are satisfied, complete quest
		#quests[id]["ready_to_complete"] = true
		#quest_updated.emit(id)
		quests[id]["completed"]=true
		quest_completed.emit(id)		#emit signal that quest is completed
		print("Quest completed")
	
	else:
		quest_updated.emit(id)		#emit signal that quest has been updated
		print(quests[id]["collected"], "/", quests[id]["required"])

func finish_quest(id:String):
	if !quests.has(id):
		return
	
	if !quests[id]["started"]:
		return
	
	if !quests[id]["completed"]:
		return
	
	if quests[id]["completed2"]:
		return
	
	quests[id]["completed2"] = true
	quest_completed2.emit(id)
	print("Quest fully completed: ", id)

#Need to add helper functions in future (if necessary)
func get_quest(id):
	if quests.has(id):
		return quests[id]
	return null
