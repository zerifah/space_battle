extends Area2D

signal exit
signal destroyed
signal crash(position:Vector2, scale:Vector2)

@onready var sprite = $Sprite2D
@onready var collisionShape = $CollisionShape2D

static var speed = 200
var health = 3 # between 1 and 3
var size = 1 # default value
var damage = 1 #on bullet crash
var delta_speed_x = randf_range(0.5, 1)
var delta_speed_y = randf_range(-0.3, 0.3)
var rotate_speed = randf_range(-30, 30)
var new_texture_health_on_2 = preload("res://asteroid/asteroid_health_2.png")
var new_texture_health_on_1 = preload("res://asteroid/asteroid_health_1.png")
var new_texture_health_on_0 = preload("res://asteroid/asteroid_health_0.png")
var new_texture_crash = preload("res://asteroid/asteroid_crash.png")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
func _ready() -> void:
	size = scale.x
	health = roundi(size * 2) # Function who give health in function of size

func _physics_process(delta: float) -> void:
	global_position.x -= delta_speed_x * speed * delta # delta = durée entre deux images, p. ex. 1/60
	global_position.y -= delta_speed_y * speed * delta
	rotation_degrees += rotate_speed * delta

# Quand l'asteroide sort de l'écran
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	exit.emit()
	queue_free() # Supprime l'élément
	
func _on_body_entered(body) :
	if body.has_method("explode") :
		body.explode()
	sprite.texture = new_texture_health_on_0
	
func die():
	queue_free()
	
func on_touch() :
	health -= damage
	if health <= 0 :
		sprite.texture = new_texture_health_on_0
		collisionShape.set_deferred("disabled", true)
		destroyed.emit()
	elif health == 1 :
		sprite.texture = new_texture_health_on_1
	elif health == 2 :
		sprite.texture = new_texture_health_on_2


func _on_area_entered(area: Area2D) -> void:
	if area.name == 'Base' :
		crash.emit(global_position, scale)
		sprite.texture = new_texture_crash
		delta_speed_x = 0 
		await get_tree().create_timer(2.0).timeout
		queue_free()
