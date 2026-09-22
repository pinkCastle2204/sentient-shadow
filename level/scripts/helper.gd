extends Label

@onready var helper: Label = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func interact():
	helper.text = "Press 'E' to interact"
	helper.visible = true
func nointeract():
	#helper.text = "Press 'E' to interact"
	helper.visible = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
