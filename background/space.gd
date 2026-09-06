extends Node

@onready var star_scene = preload("res://background/star.tscn")
@onready var star = $Stars/Star
@onready var star2 = $Stars/Star2
@onready var star3 = $Stars/Star3

var direction = 1 # direction of stars
var spawn_zone_x_min = 0
var spawn_zone_x_max = 0

func _ready() -> void:
	star.speed = star.speed * direction
	star2.speed = star2.speed * direction
	star3.speed = star3.speed * direction
	spawn_zone_x_min = get_viewport().size.x
	spawn_zone_x_max = get_viewport().size.x + 10	


func spawn_star():
	var new_star = star_scene.instantiate()
	get_node("Stars").add_child(new_star)
	var random_y = randf_range(0, get_viewport().size.y)
	var random_x = randf_range(spawn_zone_x_min,  spawn_zone_x_max)
	var size = randi_range(1, 5) * 0.2
	new_star.scale = Vector2(size, size) 
	new_star.speed = randi_range(5, 100) * direction
	new_star.position = Vector2(random_x, random_y) # Spawn at random x


func _on_timer_stars_timeout() -> void:
	spawn_star()
