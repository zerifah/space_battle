extends Node

@onready var base = $Base
@onready var player2 = $Player2
@onready var score_label = $"UserInterface/Score Label"
@onready var asteroid_scene = preload("res://asteroid/asteroid.tscn")
@onready var asteroid_timer = $AsteroidTimer
@onready var game_over_ui = $GameOver
@onready var victory_label = $"UserInterface/Victory Label"
@onready var button_next_mission = $"UserInterface/Button Next Mission"
@onready var audio_victory = $"UserInterface/Audio Victory"
@onready var next_mission = load("res://HUD/mission.tscn") 

var is_player_alive = true
var nbr_asteroids_max = 30 # 30
var nbr_asteroids_spawned = 0
var time_of_asteroid_spawning_min = 1.2
var score = 0

func _ready() -> void:
	if Settings.two_players :
		player2.move_down = "move_down_2"
		player2.move_up = "move_up_2"
		player2.move_left = "move_left_2"
		player2.move_right = "move_right_2"
		player2.shoot = "shoot_2"
		time_of_asteroid_spawning_min = 1
	else :
		player2.queue_free()
		
	base.state = 'idle'

func spawn_asteroid() -> void:
	var asteroid = asteroid_scene.instantiate()
	var random_scale = randi_range(2, 6) * 0.25
	var random_y = randf_range(0.2 * get_viewport().size.y, 0.8 * get_viewport().size.y)
	var random_x = randf_range(get_viewport().size.x, get_viewport().size.x + 10)
	asteroid.position = Vector2(random_x, random_y) # Spawn at random x
	asteroid.scale = Vector2(random_scale, random_scale)
	asteroid.destroyed.connect(_on_asteroid_destroyed)
	asteroid.crash.connect(_on_asteroid_crash)
	get_node("Asteroids").add_child(asteroid)
	nbr_asteroids_spawned += 1
	
#func _process(delta: float) -> void:
	#pass

func _on_asteroid_destroyed() -> void:
	score += 10
	score_label.text = "Score : " + str(score)

func _on_asteroid_exit() -> void:
	pass # Rien ne se passe dans ce niveau
	
func _on_asteroid_timer_timeout() -> void:
	if nbr_asteroids_spawned < nbr_asteroids_max :
		spawn_asteroid()
		asteroid_timer.wait_time *= 0.96
		if asteroid_timer.wait_time <= time_of_asteroid_spawning_min :
			asteroid_timer.wait_time = time_of_asteroid_spawning_min
	else :
		asteroid_timer.stop()
		await get_tree().create_timer(4).timeout
		victory_label.text += str(score)
		victory_label.visible = true
		score_label.visible = false
		score_label.visible = false
		button_next_mission.visible = true
		audio_victory.play()

func _on_asteroid_crash(position:Vector2, scale:Vector2) -> void:
	base.add_dommage(position, scale)
	print('Crash à la position ', position, 'de taille', scale)
	if base.health <= 0 :
		game_over()
	
func game_over() -> void:
	is_player_alive = false
	game_over_ui.visible = true
	score = 0
	for asteroid in get_node("Asteroids").get_children() :
		asteroid.speed = 250
		
func _on_player_dead() -> void:
	game_over()

func _on_button_next_mission_pressed() -> void:
	""" Bouton 'Next Mission pressé' """
	Settings.level = 2
	Settings.score = score
	get_tree().change_scene_to_packed(next_mission)
