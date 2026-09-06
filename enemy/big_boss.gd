extends Node2D

signal death_big_boss
var damages:Array 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	damages = [$Damages/Damage1, $Damages/Damage2, $Damages/Damage3, $Damages/Damage4]
	for d in damages :
		d.play('default')


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func _on_shield_body_area_entered(area: Area2D) -> void:
	area.queue_free()


func _on_shield_front_area_entered(area: Area2D) -> void:
	area.queue_free()


func _on_shield_back_area_entered(area: Area2D) -> void:
	area.queue_free()


func touched():
	if len(damages) > 0 :
		damages.pop_front().visible = true	
	else :
		await get_tree().create_timer(1.5).timeout
		death_big_boss.emit()
