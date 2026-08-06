extends Node

signal quest_started(id)
signal quest_updated(id)
signal quest_completed(id)

var quests = {}				#initially empty, will be filled upon adding quests

func _ready():
	register_quest(
		"medicine",
		"Find Medicines",
		"Collect 3 medicines for the medic",
		3,
		"Return to the medic"
	)
	#Add more quests here

#Add quests into the dictionary using this function
func register_quest(id:String, title:String, description:String,required:int,text:String):
	quests[id] = {
		"title": title,
		"description": description,
		"started": false,
		"completed": false,
		"collected": 0,
		"required": required,
		"text_upon_completion": text,
		"outcome": ""		#this will be used for quests which are based on choices
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
		quests[id]["completed"]=true
		quest_completed.emit(id)		#emit signal that quest is completed
		print("Quest completed")
		
	else:
		quest_updated.emit(id)		#emit signal that quest has been updated
		print(quests[id]["collected"], "/", quests[id]["required"])

#Need to add helper functions in future (if necessary)
func get_quest(id):
	if quests.has(id):
		return quests[id]
	return null
