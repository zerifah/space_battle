extends Node2D

# ToDO :
# 1- Je n'arrive pas à augmenter le score à chaque fois qu'un astéroide sort de l'écran,
# wle signal n'est envoyé que pour l'astéroid qui existe sur la scène LEVEL
# et non pour les asteroides qui ont 'spawné' => RESOLU : Les signaux de l'interface ne
# s'applique pas à la classe mais à l'instance sélectionnée.
# 2- quand on finit le jeu, parfois la ligne qui réinitialise la vitesse
# des asteroides plantes ('null') => résolu avec is_instance_valid ?

@onready var score_label = $"UserInterface/Score Label"
@onready var game_over_ui = $GameOver
@onready var timer_asteroid = $AsteroidsSpawner/Timer_asteroids
@onready var asteroids = $Asteroids
@onready var victory_label = $"UserInterface/Victory Label"
@onready var button_next_mission = $"UserInterface/Button Next Mission"
@onready var audio_victory = $"UserInterface/Audio Victory"
@onready var player2 = $Player2
@onready var level2 = preload("res://level_2.tscn")

#var score = 0
var is_player_alive = true
var asteroids_exited = 0
var asteroids_number = 10
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
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func _on_score_timer_timeout() -> void:
	if is_player_alive:
		Settings.score += 1
		score_label.text = "Score : " + str(Settings.score)
		for asteroid in get_node("Asteroids").get_children() :
			asteroid.speed += 1

func _on_player_dead() -> void:
	is_player_alive = false
	game_over_ui.visible = true
	for asteroid in get_node("Asteroids").get_children() :
		asteroid.speed = 250

func _on_asteroid_exit() -> void:
	asteroids_exited += 1
	if  is_player_alive:
		Settings.score += 10
		score_label.text = "Score : " + str(Settings.score)
		
		# Condition d'arret de la production d'asteroides
		if asteroids_exited >= asteroids_number :
			timer_asteroid.stop()
		
		# Condition de fin de niveau 1
		if asteroids.get_child_count() <= 1 : # Pas 0, car le dernier existe encore
			victory_label.text += str(Settings.score)
			victory_label.visible = true
			score_label.visible = false
			score_label.visible = false
			button_next_mission.visible = true
			audio_victory.play()

func _on_button_pressed() -> void:
	""" Bouton 'Next Mission pressé' """
	var level2_instance = level2.instantiate()
	get_tree().change_scene_to_packed(level2)
