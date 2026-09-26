extends Area2D
var unlocked = false
var used = false

@onready var panel=$Panel
@onready var label=$Label
var player_near =false
@onready var player: CharacterBody2D = $"../Player"

func _ready():
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)
	panel.visible=false
	label.visible=false
	
func _process(delta):
	interact()
	
func interact():
	if player_near and Input.is_action_just_pressed("interact"):
		if used:
			return
		if !QuestManager.quests["project_zero"]["completed"]:
			print("need 3 records")
			panel.visible=true
			label.visible=true
			await get_tree().create_timer(2.0).timeout
			panel.visible=false
			label.visible=false
			return

		unlocked = true
		used = true
		print("Project Zero terminal unlocked.")
		QuestManager.finish_quest("project_zero")
		get_tree().change_scene_to_file("res://scenes/Level 3/level_3_ending.tscn")

func on_body_entered(body):
	if body.name == "Player":
		player_near = true

func on_body_exited(body):
	if body.name == "Player":
		player_near = false
