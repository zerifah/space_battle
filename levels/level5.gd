extends Level


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	Settings.level = 4

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


func _on_big_boss_death_big_boss() -> void:
	Settings.score += 10000
	victory()
