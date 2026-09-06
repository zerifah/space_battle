extends Level

@onready var timer_asteroid = $AsteroidsSpawner/Timer_asteroids
@onready var base = $Base
@onready var deviator = $AsteroidDeviator
@export var two_players = false
@onready var spawner = $AsteroidsSpawner

var asteroids_exited = 0

# Value of the parametres for easy difficulty
var asteroids_number = 0 # 65


func _ready() -> void:
	super._ready()
	Settings.level = 2
	if difficult :
		spawner.spawn_time_min = 0.2
		asteroids_number = 70


func _on_score_timer_timeout() -> void:
	if is_player_alive:
		score += 10
		score_label.text = "Score : " + str(score)
		for asteroid in get_node("Asteroids").get_children() :
			asteroid.speed += 1


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


func _on_asteroid_deviator_death_deviator() -> void:
	await get_tree().create_timer(1.5).timeout
	victory()


func _on_asteroid_collision(_asteroid: Area2D, _area: Area2D) -> void:
	# Do nothing in this level
	pass # Replace with function body.
