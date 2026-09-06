extends Node
# dimension écran idéal sur ANDELL : 1152 x 920

# Le chemin user://... pointe sous Linux vers 
# : ~/.local/share/godot/app_userdata/superjeu/ 
var file_save_path = "user://game.save"
var file_best_scores = "user://best_scores.save"

# Games settings
var two_players = true #false
var difficult = false

# Global variables
var score = 0
var level = 0
var upgrade_player_1 = {
	'shield' : false,
	'reactor' : false,
	'condensator' : false,
	'accumulator' : false
}
	
var upgrade_player_2 = {
	'shield' : false,
	'reactor' : false,
	'condensator' : false,
	'accumulator' : false
}

# The players can't die when they success
var victory = false
