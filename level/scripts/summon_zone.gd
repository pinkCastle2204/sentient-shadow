extends Area2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var summon_zone: Area2D = $"."

@export var target: CharacterBody2D
@export var targetMonster: CharacterBody2D
@export var targetPlayer: CharacterBody2D
@export var companion: CharacterBody2D
var summoned:bool = false;
var played:bool = false
@export var locate : Vector2
# Called when the node enters the scene tree for the first time.
func desummon():
	companion.global_position = Vector2(455,256)
func _ready() -> void:
	body_entered.connect(on_body_entered)

func on_body_entered(body: Node2D):
	if body.is_in_group("Player") && !summoned:
		
		summoned = true
		companion.global_position = global_position
		
func playit():
	if !played:
		played = true
		audio_stream_player_2d.play()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var p: String = personality.classify_personality()
	#print(p)
	if (p == "Empathy" || p == "Brave") && targetMonster:
		companion.target = targetMonster
		playit()
		if companion.target.health < 50:
			companion.global_position = locate
			
		return
		#print("monster marega aaj")
	elif (p == "Aggresive" || p == "Selfish") && targetPlayer: 
			playit()
			companion.target = targetPlayer
			print("player marega aaj")
			if companion.target.health < 50:
				companion.global_position = locate
			return
	if companion.target != null && companion.target.health < 50:
		companion.global_position = locate 	
