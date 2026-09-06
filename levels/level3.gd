extends Level

@onready var timer_asteroid = $AsteroidsSpawner/Timer_asteroids
@onready var space = $Space
@onready var enemy_position_min = $"Enemy positions/MarkerUpLeft"
@onready var enemy_position_max = $"Enemy positions/MarkerDownRight"
@onready var star = $Space/Stars/Star
@onready var star2 = $Space/Stars/Star2
@onready var star3 = $Space/Stars/Star3
@onready var enemy_scene = preload("res://enemy/enemy.tscn")
@onready var enemy_spawn_position_up = $"Enemy positions/SpawnPointUpLeft"
@onready var enemy_spawn_position_down = $"Enemy positions/SpawnPointDownRight"
@export var two_players = false

var asteroids_exited = 0

# Value of the parametres for easy difficulty
var nbr_enemies = 8


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	Settings.level = 3
	
	if difficult :
		nbr_enemies = 10
		
	# Initialized speed if restart
	for asteroid in get_node("Asteroids").get_children() :
		asteroid.speed = 250
		
	# Change the direction of the stars
	space.direction = -1
	space.spawn_zone_x_min = -10
	space.spawn_zone_x_max = -8
	star.speed = -star.speed
	star2.speed = -star2.speed
	star3.speed = -star3.speed
	
	# Enemies	
	spawn_enemy()
	spawn_enemy()


func _on_score_timer_timeout() -> void:
	if is_player_alive:
		score += 1
		score_label.text = "Score : " + str(score)
		for asteroid in get_node("Asteroids").get_children() :
			asteroid.speed += 1


func _on_asteroid_exit() -> void:
	asteroids_exited += 1
	if  is_player_alive:
		score += 10
		score_label.text = "Score : " + str(score)


func move_enemies() -> void :
	for e in enemies.get_children() :
		move_enemy(e)


func move_enemy(enemy) -> void :
	var randoms_points = Vector2(0,0)
	randoms_points.x = randf_range(
		enemy_position_min.global_position.x,
		enemy_position_max.global_position.x
	)
	randoms_points.y = randf_range(
		enemy_position_min.global_position.y,
		enemy_position_max.global_position.y)
	enemy.next_position = randoms_points


func _on_enemy_move_finished(enemi_name) -> void:
	var enemy = enemies.get_child(enemi_name)
	move_enemy(enemy)


func spawn_enemy() -> void:
	var enemy = enemy_scene.instantiate()
	var random_y = randf_range(
		enemy_spawn_position_up.global_position.y,
		enemy_spawn_position_down.global_position.y
	)
	var random_x = randf_range(
		enemy_spawn_position_up.global_position.x,
		enemy_spawn_position_down.global_position.x
	)
	enemy.position = Vector2(random_x, random_y) # Spawn at random x
	
	# get_node("Enemies").add_child(enemy) ne peut pas etre appelé directement
	# pendant qu'il y a des requetes en cours
	call_deferred("_deferred_add", enemy)
	
	enemy.move_finished.connect(_on_enemy_move_finished)
	enemy.death.connect(_on_enemy_death)

func _deferred_add(enemy):
	get_node("Enemies").add_child(enemy)


func _on_enemy_death() -> void:
	if nbr_enemies > 2 :
		spawn_enemy()
		nbr_enemies -=1
	elif nbr_enemies > 0 :
		nbr_enemies -=1
	score += 1000
		
	if nbr_enemies == 0 :
		await get_tree().create_timer(1.5).timeout
		victory()

		
func _on_asteroid_collision(asteroid, area) -> void:
	print("collision")
	if area.get_parent().name == "Enemies" :
		if nbr_enemies > 2 : #the two last enemies can't die with asteroid
			area.explode()
			asteroid.on_touch()
