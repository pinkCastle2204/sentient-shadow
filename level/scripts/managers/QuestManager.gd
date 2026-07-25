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
		3
	)
	#Add more quests here

#Add quests into the dictionary using this function
func register_quest(id:String, title:String, description:String,required:int):
	quests[id] = {
		"title": title,
		"description": description,
		"started": false,
		"completed": false,
		"collected": 0,
		"required": required,
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
		
	quests[id]["current"] +=amt
	
	if quests[id]["current"]>=quests[id]["required"]:	#if requirements are satisfied, complete quest
		quests[id]["completed"]=true
		quest_completed.emit(id)		#emit signal that quest is completed
	
	else:
		quest_updated.emit(id)		#emit signal that quest has been updated

#Need to add helper functions in future (if necessary)
