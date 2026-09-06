extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_button_pressed() -> void:
	Settings.score -= 100
	if Settings.score < 0 :
		Settings.score = 0
	get_tree().reload_current_scene()
