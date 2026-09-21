extends Area2D

var player_near =false
var dialogue_started := false
@onready var player: CharacterBody2D = $"../Player"
@onready var monster_spawn: Marker2D=$"../MonsterSpawn"
@export var monster_scene: PackedScene

func _ready():
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)
	
	
func _process(_delta):
	var p: String = personality.classify_personality()
	print(p)
	
	if player_near and Input.is_action_just_pressed("interact"):
		if (p == "Empathy"):
			Dialogic.start("npc-empathy")
			await Dialogic.timeline_ended
			
		elif (p == "Brave"):
			Dialogic.start("npc-brave")
			await Dialogic.timeline_ended
			
		elif (p == "Aggressive" || p == "Selfish"):
			Dialogic.start("npc-aggressive")
			await Dialogic.timeline_ended
			spawn_monster()
			queue_free()
	
			
func spawn_monster():
	var monster = monster_scene.instantiate()
	get_parent().add_child(monster)
	monster.global_position = monster_spawn.global_position
	
func on_body_entered(body):
	if body.name == "Player":
		player_near = true

func on_body_exited(body):
	if body.name == "Player":
		player_near = false
