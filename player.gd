extends CharacterBody2D
class_name Player

signal dead

@onready var dimension = $CollisionShape2D
@onready var radius = dimension.shape.radius
@onready var audio = $AudioStreamPlayer2D
@onready var bullet_scene = preload("res://bullet.tscn")
@onready var timer_shoot = $TimerShoot
@onready var sprite = $AnimatedSprite2D
@onready var timer_explosion = $TimerExplosion

var speed = 500
var friction = 0.1
var acceleration = 300
var energie = 3
var recharge = 0.1
var shoot_ready = true

var move_up = "move_up"
var move_down = "move_down"
var move_left = "move_left"
var move_right = "move_right"
var shoot = "shoot"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if name == "Player" :
		sprite.play("idle_player_1")
	else :
		sprite.play("idle_player_2")

func _physics_process(delta: float) -> void:
	# En commentaire, pour un déplacement sans accélération ni frottement
		
	if Input.is_action_pressed(move_up):
		velocity.y = clamp(velocity.y, -speed, -acceleration)
		#velocity.y = -speed
	
	if Input.is_action_pressed(move_down):
		#velocity.y = speed
		velocity.y = clamp(velocity.y, speed, acceleration)
		
	if Input.is_action_pressed(move_left):
		velocity.x = -speed
	
	if Input.is_action_pressed(move_right):
		velocity.x  = speed
	
	# Pour s'arreter tranquillement	
	velocity.x = lerp(velocity.x, 0.0, friction)
	velocity.y = lerp(velocity.y, 0.0, friction)
	
	move_and_slide()
		
	# Limit_positions
	var screen_size = get_viewport_rect().size
	var position_max = Vector2(0,0)
	position_max.x = screen_size.x - radius
	position_max.y = screen_size.y - radius
	global_position = global_position.clamp(Vector2(radius,radius), position_max)
	
	#Tir
	if Input.is_action_pressed(shoot) and shoot_ready and energie >= 1:
		shoot_ready = false
		timer_shoot.start()

		var bullet = bullet_scene.instantiate()
		bullet.global_position = self.global_position
		bullet.global_position.x += radius  	
		add_child(bullet)
		
		energie -= 1
		audio.play()

	# Détection des collisions avec le deuxième joueur
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider() is CharacterBody2D or collision.get_collider() is Area2D:
			explode()
			collision.get_collider().explode()
		
func death():
	dead.emit()  
	queue_free()
		
func die():
	queue_free()

func _on_energie_timer_timeout() -> void:
	if energie < 3 :
		energie += recharge

func _on_timer_shoot_timeout() -> void:
	shoot_ready = true

func explode():
	if name == "Player" :
		sprite.play("explode_player_1")
	else :
		sprite.play("explode_player_2")
		
	await get_tree().create_timer(2.0).timeout # Créé un timer unique
	death()
