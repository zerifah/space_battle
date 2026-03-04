extends Area2D

signal death_deviator
@onready var in_position = $AsteroidInputPosition
@onready var out_position = $AsteroidOutputPosition
@onready var asteroid_scene = preload("res://asteroid/asteroid.tscn")
@onready var timer  = $TimerAsteroidSpawner
@onready var damages = $Damages

static var speed = 0
var health = 1

func _physics_process(delta: float) -> void:
	global_position.x -= speed * delta

func spawn_asteroid() -> void:
	var asteroid_in = asteroid_scene.instantiate()
	asteroid_in.position = Vector2(in_position.global_position.x + 100, in_position.global_position.y) # Spawn at random x
	asteroid_in.delta_speed_y = 0
	get_node("Asteroids").add_child(asteroid_in)
	
	var asteroid_out = asteroid_scene.instantiate()
	asteroid_out.position = Vector2(out_position.global_position.x, out_position.global_position.y) # Spawn at random x
	asteroid_out.delta_speed_y = 0
	asteroid_out.z_index = 0
	get_node("Asteroids").add_child(asteroid_out)
	
	await get_tree().create_timer(1).timeout
	asteroid_in.queue_free()
	timer.start()

func _on_timer_asteroid_spawner_timeout() -> void:
	if health > 0 :
		spawn_asteroid()
		
func death() :
	damages.play("default")
	await get_tree().create_timer(0.4).timeout
	damages.visible = true
	timer.stop()
	death_deviator.emit()
	
