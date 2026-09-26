extends Area2D

var player_near =false
var dialogue_started := false
@onready var player: CharacterBody2D = $"../Player"

func _ready():
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)
	
func _process(_delta):
	if player_near and Input.is_action_just_pressed("interact"):
		start_dialogue()
	
func on_body_entered(body):
	if body.name == "Player":
		player_near = true

func on_body_exited(body):
	if body.name == "Player":
		player_near = false

func start_dialogue():
	if dialogue_started:
		return

	dialogue_started = true
	player.can_move = false
	player.animated_sprite_2d.stop()

	Dialogic.start("refugee-child")
	await Dialogic.timeline_ended

	player.can_move = true
	dialogue_started = false
	if Dialogic.VAR.save_child:
		QuestManager.start_quest("rescue_child")
