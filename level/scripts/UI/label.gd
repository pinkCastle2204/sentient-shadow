extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	personality.classify_personality()
	self.text = personality.best_name


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	personality.classify_personality()
	self.text = personality.best_name
