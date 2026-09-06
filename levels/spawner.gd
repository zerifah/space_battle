extends Node2D

@onready var markers = $Markers
@onready var timer_asteroids = $Timer_asteroids
@onready var asteroid_scene = preload("res://asteroid/asteroid.tscn")
@onready var star_scene = preload("res://background/star.tscn")

var size_min = 0.4
var size_max = 1.6
var acceleration_spawn_timer = 0.98
var spawn_time_min = 0.3

func _on_timer_asteroids_timeout() -> void:
	var random_point = markers.get_children().pick_random()
	var asteroid = asteroid_scene.instantiate()
	
	# Définit la taille de l'astéroide
	var size = randf_range(size_min, size_max)
	asteroid.scale = Vector2(size, size)
	asteroid.global_position = random_point.global_position
	asteroid.exit.connect(get_parent()._on_asteroid_exit)
	asteroid.collision.connect(get_parent()._on_asteroid_collision)
	get_parent().get_node("Asteroids").add_child(asteroid)
	if timer_asteroids.wait_time > spawn_time_min :
		timer_asteroids.wait_time = acceleration_spawn_timer * timer_asteroids.wait_time


func _on_asteroid_exit() -> void:
	pass # Replace with function body.
