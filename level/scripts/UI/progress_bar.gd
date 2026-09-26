extends ProgressBar



@onready var player: CharacterBody2D = $"../../Player"



func _ready()->void:
	print(player)
	print(player.get_script())
	print("health =", player.get("health"))
	
	await get_tree().process_frame
	if(player.health != null): value = player.health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(player.health != null): value = player.health
