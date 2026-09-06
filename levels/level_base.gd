extends Node
class_name Level

@onready var victory_label = $"UserInterface/Victory Label"
@onready var button_next_mission = $"UserInterface/Button Next Mission"
@onready var audio_victory = $"UserInterface/Audio Victory"
@onready var score_label = $"UserInterface/Score Label"
@onready var game_over_ui = $GameOver
@onready var player = $Player
@onready var player2 = $Player2
@onready var next_mission = load("res://HUD/mission.tscn")
@onready var enemies = $Enemies
@onready var menu = $UserInterface/Menu
@onready var victory_scene = preload("res://HUD/victory.tscn")
@onready var asteroids = $Asteroids

var score = Settings.score
var is_player_alive = true
var difficult = Settings.difficult


func _ready() -> void:
	Settings.victory = false
	set_second_player()
	score_label.text = "Score : " + str(score)


func _process(_delta: float) -> void:
	if Input.is_action_pressed("escape"):
		menu.visible = true
		get_tree().paused = true


func set_second_player() :
	if Settings.two_players :
		player2.move_down = "move_down_2"
		player2.move_up = "move_up_2"
		player2.move_left = "move_left_2"
		player2.move_right = "move_right_2"
		player2.shoot = "shoot_2"
	else :
		player2.queue_free()


func victory() -> void :
	if is_player_alive :
		victory_label.text += str(score)
		victory_label.visible = true
		Settings.victory = true
		score_label.visible = false
		score_label.visible = false
		button_next_mission.visible = true
		audio_victory.play()


func _on_button_next_mission_pressed() -> void:
	""" Bouton 'Next Mission pressé' """
	Settings.score = score + 1000
	Settings.level += 1
	print(next_mission)
	if Settings.level == 5 :
		print("Go écran des scores")
		get_tree().change_scene_to_packed(victory_scene)
	else :
		print("go niveau suivant")
		get_tree().change_scene_to_packed(next_mission)


func _on_player_dead() -> void:
	game_over()


func game_over() -> void:
	is_player_alive = false
	game_over_ui.visible = true
	score = 0
	game_over_ui.get_node("Audio").playing = true


func _on_menu_save() -> void:
	var config := ConfigFile.new()
	
	# Saves settings
	config.set_value("settings", "score", Settings.score)
	config.set_value("settings", "level", Settings.level)
	config.set_value("settings", "two_players", Settings.two_players)
	config.set_value("settings", "difficult", Settings.difficult)
	config.set_value("settings", "upgrade_player_1", Settings.upgrade_player_1)
	config.set_value("settings", "upgrade_player_2", Settings.upgrade_player_2)
	config.set_value("settings", "victory", Settings.victory)
	
	# Saves players
	config.set_value("player", "position", player.position)
	config.set_value("player", "energy", player.energy)
	
	if Settings.two_players :
		config.set_value("player2", "position", player2.position)
		config.set_value("player2", "energy", player2.energy)
	
	# Save asteroids
	var asteroids_list := []
	for asteroid in asteroids.get_children() :
		asteroids_list.push_back({
			position = asteroid.position,
			scale = asteroid.scale,
			health = asteroid.size, 
			size = asteroid.health, # default value
			delta_speed_x = asteroid.delta_speed_x,
			delta_speed_y = asteroid.delta_speed_y,
			rotate_speed = asteroid.rotate_speed
		})
	
	config.set_value("asteroids", "asteroids", asteroids_list)
	config.save(Settings.file_save_path)
	print('Game saved')

func _on_menu_load() -> void:
	var config := ConfigFile.new()
	config.load(Settings.file_save_path)
	player.position = config.get_value("player", "position")
	player.energy = config.get_value("player", "energy")
	if Settings.two_players :
		player2.position = config.get_value("player2", "position")
		player2.energy = config.get_value("player2", "energy")

	# Remove existing asteroids before adding new ones.
	for asteroid in asteroids.get_children():
		asteroid.queue_free()
	# Load Asteroids
	var asteroids_list: Array = config.get_value("asteroids", "asteroids")
	for asteroid: Dictionary in asteroids_list:
		var asteroid_loaded:= preload("res://asteroid/asteroid.tscn").instantiate()
		asteroid_loaded.position = asteroid.position
		asteroid_loaded.scale = asteroid.scale
		asteroid_loaded.health = asteroid.size 
		asteroid_loaded.size = asteroid.health
		asteroid_loaded.delta_speed_x = asteroid.delta_speed_x
		asteroid_loaded.delta_speed_y = asteroid.delta_speed_y
		asteroid_loaded.rotate_speed = asteroid.rotate_speed
		asteroids.add_child(asteroid_loaded)
