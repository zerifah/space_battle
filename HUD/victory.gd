extends Node2D

@onready var score_label = $"NameInputForm/Score Label"
@onready var submit_button = $NameInputForm/SubmitButton
@onready var name_input_form = $NameInputForm
@onready var name_input = $NameInputForm/NameInput
@onready var score_list = $ScoreList

var name_player = ""
var scores = []
var score = Settings.score

func _ready() -> void:
	score_label.text = str(Settings.score)
	submit_button.pressed.connect(_on_submit_pressed)
	name_input.text_submitted.connect(_on_name_submitted)
	load_scores()


func save_scores() :
	# Only the 9 best scores are saved
	if scores.size() > 9:
		scores.pop_back()
		
	var config := ConfigFile.new()
	config.set_value("Scores", "scores", scores)
	config.save(Settings.file_best_scores)
	print('Score added')


func sort_score(liste: Array) -> Array:
	var resultat = liste.duplicate()
	resultat.sort_custom(_compare_score)
	resultat.reverse()
	return resultat


func _compare_score(a: Array, b: Array) -> bool:
	"""Fonction de comparaison pour le tri."""
	return a[1] < b[1]


func load_scores():
	var config := ConfigFile.new()
	config.load(Settings.file_best_scores)
	if config.get_value("Scores", "scores") != null :
		scores = config.get_value("Scores", "scores")


func _on_name_submitted(player_name: String):
	name_player = player_name.strip_edges()
	
	if player_name.strip_edges().is_empty():
		print("Veuillez entrer un nom valide")
		return
	else :
		name_player = player_name.strip_edges()
		name_input_form.queue_free()
		scores.append([name_player, score])
		scores = sort_score(scores)
		display_scores()
		save_scores()


func display_scores() :
	var already = false # Si deux fois meme nom et score, une seule fois en vert
	for s in scores:
		var horizontal_box = HBoxContainer.new()
		var label_name = Label.new()
		var label_score = Label.new()
		label_name.text = s[0]
		label_score.text = str(s[1])
		label_name.custom_minimum_size.x = 300
		label_name.add_theme_font_size_override("font_size", 24)
		label_score.add_theme_font_size_override("font_size", 24)
		if s[0] == name_player and s[1] == score and not already :
			label_name.add_theme_color_override("font_color", Color.GREEN)
			label_score.add_theme_color_override("font_color", Color.GREEN)
			already = true
		horizontal_box.add_child(label_name)
		horizontal_box.add_child(label_score)
		score_list.add_child(horizontal_box)


func _on_submit_pressed():
	_on_name_submitted(name_input.text)
