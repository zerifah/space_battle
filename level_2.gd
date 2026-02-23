extends Node2D

@onready var score_label = $"UserInterface/Score Label"
@onready var player2 = $Player2
@onready var background = $Space/Background/TextureRect
@onready var game_over_ui = $GameOver

var is_player_alive = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var new_background = load("res://background/purple.png")
	background.texture = new_background
	score_label.text = "Score : " + str(Settings.score)
	if Settings.two_players :
		player2.move_down = "move_down_2"
		player2.move_up = "move_up_2"
		player2.move_left = "move_left_2"
		player2.move_right = "move_right_2"	
		player2.shoot = "shoot_2"
	else :
		player2.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_player_dead() -> void:
	is_player_alive = false
	game_over_ui.visible = true
