extends Control

@onready var mission = preload("res://HUD/mission.tscn")

func _ready() -> void:
	Settings.level = 1
	
func _on_button_quit_button_down() -> void:
	get_tree().quit()

func _on_button_start_button_down() -> void:
	get_tree().change_scene_to_packed(mission)

func _on_button_start_2_button_down() -> void:
	Settings.two_players = true
	get_tree().change_scene_to_packed(mission)
