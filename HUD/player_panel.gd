extends Node

class_name PlayerManager

var buttons: Array
var up: String
var down: String
var index_selected: int = 0

func _init(p_buttons: Array, p_up: String, p_down: String):
	buttons = p_buttons
	up = p_up
	down = p_down
	index_selected = 0

func _ready():
	# Initialiser l'affichage
	update()
	
	# Connecter les signaux des boutons
	for i in range(buttons.size()):
		buttons[i].pressed.connect(_on_button_pressed.bind(i))

func _process(_delta):
	# Déplacement vers le haut
	if Input.is_action_just_pressed(up):
		index_selected = (index_selected - 1) % buttons.size()
		update()
	
	# Déplacement vers le bas
	if Input.is_action_just_pressed(down):
		index_selected = (index_selected + 1) % buttons.size()
		update()

func update():
	# Réinitialiser tous les boutons
	for i in range(buttons.size()):
		buttons[i].modulate = Color.WHITE
	
	# Mettre en évidence le bouton sélectionné
	buttons[index_selected].modulate = Color.YELLOW
	
func _on_button_pressed(index: int):
	index_selected = index
	update()
	print("Joueur a choisi le bouton %d" % (index + 1))
