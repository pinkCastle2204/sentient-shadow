extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = str(personality.compassion) + " " +  str(personality.greed) +" " +  str(personality.violence) + " " +  str(personality.courage)
