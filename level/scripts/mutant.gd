extends Area2D
var player_near =false
var talked =false

func _ready():
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)
	Dialogic.signal_event.connect(is_dead)
	
func _process(_delta):
	if player_near and Input.is_action_just_pressed("interact"):
		if !talked:
			run_dialogue("MutantMeet")
			talked = true

func is_dead(argument):
	if argument=="killed":
		queue_free()
		
func run_dialogue(dialogue):
	Dialogic.start(dialogue)
	
func on_body_entered(body):
	if body.name == "Player":
		player_near = true

func on_body_exited(body):
	if body.name == "Player":
		player_near = false
