extends Node

@onready var star_scene = preload("res://star.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_star():
	var star = star_scene.instantiate()
	get_node("Stars").add_child(star)
	var random_y = randf_range(0, get_viewport().size.y)
	var random_x = randf_range(get_viewport().size.x, get_viewport().size.x + 10)
	var size = randi_range(1, 5) * 0.2
	star.scale = Vector2(size, size) 
	star.position = Vector2(random_x, random_y) # Spawn at random x

func _on_timer_stars_timeout() -> void:
	spawn_star()
