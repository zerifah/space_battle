extends Node2D

@onready var score_label = $"UserInterface/Score Label"
@onready var player2 = $Player2
@onready var background = $Space/Background/TextureRect
@onready var game_over_ui = $GameOver
@onready var enemy_scene = preload("res://enemy/enemy.tscn")
@onready var enemies = $Enemies
@onready var enemy_position_min = $"Enemy positions/MarkerUpLeft"
@onready var enemy_position_max = $"Enemy positions/MarkerDownRight"
@onready var enemy_spawn_position_up = $"Enemy positions/SpawnPointUpLeft"
@onready var enemy_spawn_position_down = $"Enemy positions/SpawnPointDownRight"

var is_player_alive = true
var score = Settings.score
var nbr_enemies_spawned = 2
var enemies_waves = [5, 6, 7, 10, 12, 15]

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


func _process(delta: float) -> void:
	if nbr_enemies_spawned == 0 and len(enemies_waves) > 0 :
		await get_tree().create_timer(1)
		nbr_enemies_spawned = enemies_waves.pop_front()
	
		for i in range(nbr_enemies_spawned):
			spawn_enemy()
			await get_tree().create_timer(1)
		
		move_enemies()

func _on_player_dead() -> void:
	is_player_alive = false
	game_over_ui.visible = true

	
func move_enemies() -> void :
	for enemy in enemies.get_children() :
		move_enemy(enemy)


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


func spawn_enemy() -> void:
	var enemy = enemy_scene.instantiate()
	var random_y = randf_range(
		enemy_spawn_position_up.global_position.y,
		enemy_spawn_position_down.global_position.y
	)
	enemy.move_finished.connect(_on_enemy_move_finished)
	enemy.death.connect(_on_enemy_death)
	
	var random_x = randf_range(
		enemy_spawn_position_up.global_position.x,
		enemy_spawn_position_down.global_position.x
	)
	enemy.position = Vector2(random_x, random_y) # Spawn at random x
	get_node("Enemies").add_child(enemy)
		
	
func _on_enemy_move_finished(enemi_name) -> void:
	var enemy = enemies.get_child(enemi_name)
	move_enemy(enemy)


func _on_enemy_death() -> void:
	score += 10
	score_label.text = "Score : " + str(score)
	nbr_enemies_spawned -= 1
