extends Area2D

var player_near =false
@onready var player: CharacterBody2D = $"../Player"

func _ready():
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)
	
func _process(_delta):
	pass
	
func on_body_entered(body):
	if body.name == "Player":
		player_near = true

func on_body_exited(body):
	if body.name == "Player":
		player_near = false
