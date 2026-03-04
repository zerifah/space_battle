extends Node2D

@onready var score_label = $"UserInterface/Score Label"
@onready var player2 = $Player2
@onready var background = $Space/Background/TextureRect
@onready var game_over_ui = $GameOver
@onready var enemies = $Enemies
@onready var enemy_positions = $"Enemy positions"

var is_player_alive = true
var score = Settings.score


func _ready() -> void:
	var new_background = load("res://background/purple.png")
	background.texture = new_background
	score_label.text = "Score : " + str(score)
	if Settings.two_players :
		player2.move_down = "move_down_2"
		player2.move_up = "move_up_2"
		player2.move_left = "move_left_2"
		player2.move_right = "move_right_2"	
		player2.shoot = "shoot_2"
	else :
		player2.queue_free()
	move_enemies()


func _on_player_dead() -> void:
	is_player_alive = false
	game_over_ui.visible = true

	
func move_enemies() -> void :
	for enemy in enemies.get_children() :
		move_enemy(enemy)


func move_enemy(enemy) -> void :
	var randoms_points = enemy_positions.get_children().pick_random().global_position
	enemy.next_position = randoms_points

	
func _on_enemy_move_finished(name) -> void:
	var enemy = enemies.get_child(name)
	move_enemy(enemy)
