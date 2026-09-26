extends Area2D

var player_near =false
var rescued=false
@onready var color_rect: ColorRect = $"../CanvasLayer/ColorRect"
@onready var monster=$"../Level3boss"
@onready var player=$"../Player"

func _ready():
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)
	
func _process(_delta):
	if player_near and Input.is_action_just_pressed("interact"):
		interact()
		
func interact():
	if rescued:
		return

	# Quest has not been accepted
	if !QuestManager.quests["rescue_child"]["started"] and !is_instance_valid(monster):
		Dialogic.start("child-before-quest")
		return

	# Monster is still alive
	if is_instance_valid(monster):
		Dialogic.start("child-monster-alive")
		return

	# Monster has been defeated
	rescued = true
	QuestManager.add_progress("rescue_child")
	Dialogic.start("child-rescued")
	await Dialogic.timeline_ended
	print("started fading to black")
	await fade_to_black(1.5)
	print("Faded to black")
	player.global_position=$"../Refugee/PlayerReturn".global_position
	global_position=$"../Refugee/ChildReturn".global_position
	await fade_from_black(1.5)
	
	QuestManager.finish_quest("rescue_child")
	await personality.start_dialogue("refugee-after-child-rescued")
	print("comp",personality.compassion)
	print("greed",personality.greed)
	print("vio",personality.violence)
	print("cour",personality.courage)
	
func on_body_entered(body):
	if body.name == "Player":
		player_near = true

func on_body_exited(body):
	if body.name == "Player":
		player_near = false
		
func fade_to_black(time) -> void:
	var tween = create_tween()
	tween.tween_property(color_rect, "color", Color(0, 0, 0, 1), time)
	await tween.finished

func fade_from_black(time)->void:
	var tween = create_tween()
	tween.tween_property(color_rect, "color", Color(0, 0, 0, 0), time)
	await tween.finished
