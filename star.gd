extends Node2D

var speed = randi_range(5, 100)

func _physics_process(delta: float) -> void:
	global_position.x -= speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
