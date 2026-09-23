extends Area2D

@onready var player: CharacterBody2D = $"../Player"
@onready var bruteforce: CanvasLayer = $"../bruteforce"
var done: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.signal_event.connect(dialogic_signal)

@onready var break_the_system: CanvasLayer = $"../BreakTheSystem"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
		pass
		
		

func run_dialogue() -> void:
	QuestManager.start_quest("computer")
	done = true
	player.player_inte = true
	Dialogic.start("ComputerAccess")
	await Dialogic.timeline_ended
	player.player_inte = false
	
	
func dialogic_signal(arg: String) -> void:
	match arg:
		"Computer_brute_force":
			personality.update_personality([0, 5, 0, 10])
			bruteforce.visible = true
			  # patient, calculated risk — mild greed/courage
			 # or just a timed password prompt with higher stakes
		"Computer_break_drive":
			personality.update_personality([-10, 5, 20, 15]) 
			break_the_system.visible = true
			# forceful, destructive
	QuestManager.add_progress("computer")
	QuestManager.finish_quest("computer")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") && !done:
		player.player_inte = true
		run_dialogue()
	
