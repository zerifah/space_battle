extends Node2D

@onready var dommage_scene = preload("res://base/damage.tscn")

var speed = 0
var state = 'moving'
var health = 4
var scale_dommage_factor = 0.4

func _physics_process(delta: float) -> void:
	if state == 'moving' :
		global_position.x -= speed * speed * delta # delta = durée entre deux images, p. ex. 1/60
		speed += 0.2
	else :
		speed = 0

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func add_dommage(new_position:Vector2, value:Vector2):
	health -= value.x
	var dommage = dommage_scene.instantiate()
	var shift = Vector2(50, 0)
	dommage.global_position = new_position - shift
	dommage.scale = scale_dommage_factor * value
	get_node('Damages').add_child(dommage)
	dommage.play('default')
	
