extends Area2D

signal move_finished()

@onready var dimension = $CollisionShape2D
@onready var radius = dimension.shape.radius
@onready var audio = $AudioStreamPlayer2D
@onready var bullet_scene = preload("res://bullet.tscn")
@onready var timer_shoot = $TimerShoot
@onready var sprite = $AnimatedSprite2D
#@onready var timer_explosion = $TimerExplosion
@onready var shootarea = $ShootArea/CollisionShape2D
@onready var next_position = global_position
var speed = 200
var friction = 0.1
var acceleration = 300
var energie = 3
var recharge = 0.1
var target_in_sight = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Tirs
	var bodies = $ ShootArea.get_overlapping_bodies()
	if len(bodies) > 0 and timer_shoot.is_stopped() :
		shoot()
		timer_shoot.start()
	move(delta)
		
func move(delta: float) -> void:
	if next_position.distance_squared_to(global_position) < 10 :
		move_finished.emit()
	else :
		var direction =	(global_position - next_position).normalized()
		global_position.x -= direction.x * speed * delta
		global_position.y -= direction.y * speed * delta

func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.shooter = self
	bullet.global_position = self.global_position
	bullet.global_position.x -= radius
	bullet.speed = - bullet.speed
	add_child(bullet)
	
	energie -= 1
	audio.play()

func _on_timer_shoot_timeout() -> void:
	shoot()
	
func explode():
	sprite.play("explode")
	await get_tree().create_timer(1.0).timeout # Créé un timer unique
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	var shooter = area.get_parent()
	if shooter != self :
		explode()
