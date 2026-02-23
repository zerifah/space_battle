extends Node2D

var speed = 0

func _physics_process(delta: float) -> void:
	global_position.x -= speed * speed * delta # delta = durée entre deux images, p. ex. 1/60
	speed += 0.2

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
