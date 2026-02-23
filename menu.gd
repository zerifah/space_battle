extends Control

@onready var level1 = preload("res://level.tscn")

func _on_button_quit_button_down() -> void:
	get_tree().quit()


func _on_button_start_button_down() -> void:
	Settings.two_players = false
	get_tree().change_scene_to_packed(level1)


func _on_button_start_2_button_down() -> void:
	Settings.two_players = true
	get_tree().change_scene_to_packed(level1)
	
	

	
