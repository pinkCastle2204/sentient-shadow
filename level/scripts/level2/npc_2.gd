extends Node
@onready var npc2 = $AnimatedSprite2D

var player_nearby := false
var dialogue_running := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func start_dialogue_npc2():
	if dialogue_running:
		return

	dialogue_running = true
	await personality.start_dialogue("level2_selfish")
	dialogue_running = false
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	npc2.play("default")
	if player_nearby and Input.is_action_just_pressed("interact"):
		start_dialogue_npc2()


func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_nearby = true

func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_nearby = false
