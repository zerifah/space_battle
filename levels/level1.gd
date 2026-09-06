extends Level

@onready var base = $Base
@onready var asteroid_scene = preload("res://asteroid/asteroid.tscn")
@onready var asteroid_timer = $AsteroidTimer

# Value of the parametres for easy difficulty
var nbr_asteroids_max = 30 # 30
var nbr_asteroids_spawned = 0
var time_of_asteroid_spawning_min = 1.9

func _ready() -> void:
	Settings.level = 1
	super._ready()
	base.state = 'idle'

	# Initialized speed if restart
	for asteroid in get_node("Asteroids").get_children() :
		asteroid.speed = 250
		
	if difficult :
		nbr_asteroids_max = 40
		time_of_asteroid_spawning_min = 1.5
			
	if Settings.two_players :
		time_of_asteroid_spawning_min -= 0.4

func spawn_asteroid() -> void:
	var asteroid = asteroid_scene.instantiate()
	var random_scale = randi_range(2, 6) * 0.25
	# Pour spawner un peu à droite de la vue visible :
	# (Les lignes suivantes ne fonctionnent pas car elles dépendent
	# de l'étirement de la fenetre :
	# var random_y = randf_range(0.2 * get_viewport().size.y, 0.8 * get_viewport().size.y)
	# var random_x = randf_range(get_viewport().size.x, get_viewport().size.x + 10)
	# )
	
	var rectange_visible := get_viewport().get_visible_rect()
	var random_y = randf_range(0.2 * rectange_visible.size.y, 0.8 * rectange_visible.size.y)
	var random_x = randf_range(rectange_visible.size.x, rectange_visible.size.x + 10)
	asteroid.position = Vector2(random_x, random_y) # Spawn at random x
	asteroid.scale = Vector2(random_scale, random_scale)
	asteroid.destroyed.connect(_on_asteroid_destroyed)
	asteroid.crash.connect(_on_asteroid_crash)
	asteroid.collision.connect(_on_asteroid_collision)
	
	get_node("Asteroids").add_child(asteroid)
	nbr_asteroids_spawned += 1


func _on_asteroid_destroyed() -> void:
	score += 10
	score_label.text = "Score : " + str(score)


func _on_asteroid_timer_timeout() -> void:
	if nbr_asteroids_spawned < nbr_asteroids_max :
		spawn_asteroid()
		asteroid_timer.wait_time *= 0.96
		if asteroid_timer.wait_time <= time_of_asteroid_spawning_min :
			asteroid_timer.wait_time = time_of_asteroid_spawning_min
	else :
		asteroid_timer.stop()
		await get_tree().create_timer(5).timeout
		victory()


func _on_asteroid_crash(position:Vector2, scale:Vector2) -> void:
	base.add_dommage(position, scale)
	#print('Crash à la position ', position, 'de taille', scale)
	if base.health <= 0 :
		game_over()


func _on_asteroid_collision(asteroid, area) -> void:
	if area.name == 'Base' :
		asteroid.crash.emit(asteroid.global_position, asteroid.scale)
		asteroid.sprite.texture = asteroid.new_texture_crash
		asteroid.delta_speed_x = 0 
		await get_tree().create_timer(2.0).timeout
		asteroid.queue_free()
