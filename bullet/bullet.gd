extends Area2D

var speed = 500
#var harmless = true
var shooter = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_as_top_level(true) # sinon, le projectile se déplacera avec son parent
	# car il hérite des transformations de son parent position, rotation et échelle.
	
#func _process(delta: float) -> void:
	#pass

func _physics_process(delta: float) -> void:
	global_position.x += speed * delta # delta = durée entre deux images, p. ex. 1/60

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free() # Supprime l'élément

func _on_area_shape_entered(_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	if area.has_method('on_touch') :
		area.on_touch()
	if area.name == "AsteroidDeviator" :
		area.death()
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	# Si le body entrant n'est pas l'émetteur du projectile
	if get_parent() != body :
		##explode()
		body.explode()
		queue_free()
