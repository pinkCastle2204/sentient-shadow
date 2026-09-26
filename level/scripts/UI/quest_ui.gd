extends CanvasLayer

@onready var active =$ActiveQuest
@onready var title=$ActiveQuest/MarginContainer/VBoxContainer/Title
@onready var progress=$ActiveQuest/MarginContainer/VBoxContainer/Progress
@onready var popup =$Popup
@onready var popup_text=$Popup/Message


func _ready():
	active.visible = false
	popup.visible=false
	QuestManager.quest_started.connect(on_quest_started)
	QuestManager.quest_updated.connect(on_quest_updated)
	QuestManager.quest_completed.connect(on_quest_completed)
	QuestManager.quest_completed2.connect(on_quest_completed2)
	
func _process(delta):
	if Input.is_action_just_pressed("open_quest"):
		print("Q Key Pressed! Toggling window...")
		active.visible=!active.visible
	
	
func on_quest_started(id):
	update()
	show_popup("New Quest: " + QuestManager.quests[id]["title"])
	
func on_quest_updated(id):
	update()
	
func on_quest_completed(id):
	update()
	show_popup("Quest Completed:" + QuestManager.quests[id]["title"])

func on_quest_completed2(id):
	update()
	
func update():
	var text=""
	for id in QuestManager.quests:
		var quest = QuestManager.quests[id]
		
		if quest["started"] and !quest["completed"] and !quest["completed2"]:
			text+=quest["description"]+"\n"
			text+=str(quest["collected"]) + "/" + str(quest["required"])+"\n"
		
		if quest["completed"] and !quest["completed2"]:
			text+=quest["text_upon_completion"]
			
	if text=="":
		text="No Active Quests"
	progress.text=text
			
func show_popup(message):
	popup.visible=true
	popup_text.text=message
	await get_tree().create_timer(2).timeout
	popup.visible=false
