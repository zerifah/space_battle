extends Control

signal save
signal load

@onready var mission = preload("res://HUD/mission.tscn")
@onready var start_items = $"VBoxContainer/Start"
@onready var button_easy = $VBoxContainer/Start/HBoxDifficulty/ButtonEasy
@onready var button_hard = $VBoxContainer/Start/HBoxDifficulty/ButtonHard
@onready var button_1_player = $VBoxContainer/Start/HBoxNumberPlayers/Button1Player
@onready var button_2_players = $VBoxContainer/Start/HBoxNumberPlayers/Button2Players
@onready var button_load = $VBoxContainer/ButtonLoad
@onready var button_save = $VBoxContainer/ButtonSave 
@onready var button_resume = $VBoxContainer/ButtonResume

var number_of_players = 1

func _ready() -> void:
	# Menu in the game
	if get_parent() != get_tree().root :
		start_items.visible = false
	# Menu start
	else : 
		button_save.visible = false
		button_resume.visible = false


func _on_button_start_button_down() -> void:
	Settings.two_players = button_2_players.button_pressed
	Settings.difficult = button_hard.button_pressed
	Settings.level = 1
	get_tree().change_scene_to_packed(mission)


func _on_button_easy_toggled(toggled_on: bool) -> void:
	if toggled_on :
		button_hard.button_pressed = false
	else : 
		button_hard.button_pressed = true


func _on_button_hard_toggled(toggled_on: bool) -> void:
	if toggled_on :
		button_easy.button_pressed = false
	else : 
		button_easy.button_pressed = true
	

func _on_button_1_player_toggled(toggled_on: bool) -> void:
	if toggled_on :
		button_2_players.button_pressed = false
	else : 
		button_2_players.button_pressed = true


func _on_button_2_players_toggled(toggled_on: bool) -> void:
	if toggled_on :
		button_1_player.button_pressed = false
	else : 
		button_1_player.button_pressed = true


func _on_button_load_button_down() -> void:
	print('Game loaded')
	load.emit()
	visible = false
	await get_tree().create_timer(1).timeout
	get_tree().paused = false
	


func _on_button_quit_button_down() -> void:
	get_tree().quit()


func _on_button_resume_button_down() -> void:
	get_tree().paused = false
	visible = false


func save_game():
	# Le chemin user://... pointe sous Linux vers 
	# : ~/.local/share/godot/app_userdata/superjeu/ 
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")

		# JSON provides a static method to serialized JSON string.
		var json_string = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.
		save_file.store_line(json_string)

func _on_button_save_button_down() -> void:
	print('Save')
	save.emit()
	visible = false
	await get_tree().create_timer(1).timeout
	get_tree().paused = false
