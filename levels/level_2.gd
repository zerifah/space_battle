extends Node2D

@onready var score_label = $"UserInterface/Score Label"
@onready var game_over_ui = $GameOver
@onready var timer_asteroid = $AsteroidsSpawner/Timer_asteroids
@onready var asteroids = $Asteroids
@onready var victory_label = $"UserInterface/Victory Label"
@onready var button_next_mission = $"UserInterface/Button Next Mission"
@onready var audio_victory = $"UserInterface/Audio Victory"
@onready var player2 = $Player2
@onready var level4 = preload("res://levels/level_4.tscn")
@onready var base = $Base
@onready var deviator = $AsteroidDeviator

var score = Settings.score
var is_player_alive = true
var asteroids_exited = 0
var asteroids_number = 65 # 65
@export var two_players = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Settings.two_players :
		player2.move_down = "move_down_2"
		player2.move_up = "move_up_2"
		player2.move_left = "move_left_2"
		player2.move_right = "move_right_2"
		player2.shoot = "shoot_2"
	else :
		player2.queue_free()
	
	
func game_over() ->void :
	print(name,  'is dead')
	is_player_alive = false
	game_over_ui.visible = true
	for asteroid in get_node("Asteroids").get_children() :
		asteroid.speed = 250
		
func _on_score_timer_timeout() -> void:
	if is_player_alive:
		score += 1
		score_label.text = "Score : " + str(score)
		for asteroid in get_node("Asteroids").get_children() :
			asteroid.speed += 1
			

func _on_player_dead() -> void:
	game_over()


func _on_asteroid_exit() -> void:
	asteroids_exited += 1
	if  is_player_alive:
		score += 10
		score_label.text = "Score : " + str(score)
		
		# Condition d'arret de la production d'asteroides
		if asteroids_exited >= asteroids_number :
			timer_asteroid.stop()
		
		# Condition de fin de niveau 1
		if asteroids.get_child_count() <= 1 : # Pas 0, car le dernier existe encore
			asteroid_deviator()
			

func asteroid_deviator() -> void :
	deviator.speed = 180
	await get_tree().create_timer(5.2).timeout
	deviator.speed = 0
	get_tree().paused = true
	get_node('UserInterface').get_node('BackgroundText').visible = true
	get_node('UserInterface').get_node('TextDeviator').visible = true
	await get_tree().create_timer(9).timeout
	get_node('UserInterface').get_node('BackgroundText').visible = false
	get_node('UserInterface').get_node('TextDeviator').visible = false
	await get_tree().create_timer(0.5).timeout
	get_tree().paused = false
	deviator.spawn_asteroid()
	deviator.get_node("CollisionShape2D").disabled = false


func _on_button_pressed() -> void:
	""" Bouton 'Next Mission pressé' """
	Settings.score = score
	#var level4_instance = level4.instantiate()
	get_tree().change_scene_to_packed(level4)


func _on_asteroid_deviator_death_deviator() -> void:
	await get_tree().create_timer(1.5).timeout
	victory()


func victory() -> void :
	victory_label.text += str(score)
	victory_label.visible = true
	score_label.visible = false
	score_label.visible = false
	button_next_mission.visible = true
	audio_victory.play()
