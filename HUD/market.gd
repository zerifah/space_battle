extends CanvasLayer

@onready var button_shield1 = $HBoxContainer/UpgradePlayer1/ButtonShield1
@onready var button_shield2 = $HBoxContainer/UpgradePlayer2/ButtonShield2

var p1_buttons = []
var p2_buttons = []
var p1_index = 0
var p2_index = 0
var p1_focus: Control
var p2_focus: Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Mouse disable
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Focus on the first button
	#button_shield1.grab_focus()
#	button_shield2.grab_focus()

# Récupérer les boutons de chaque joueur
	p1_buttons = [
		$HBoxContainer/UpgradePlayer1/ButtonShield1,
		$HBoxContainer/UpgradePlayer1/ButtonReactor1,
	 	$HBoxContainer/UpgradePlayer1/ButtonCondensator1,
		$HBoxContainer/UpgradePlayer1/ButtonAccumulor1
	]
	
	#var player1_manager = PlayerManager.new(p1_buttons, "ui_up_p1", "ui_down_p1", $Joueur1/Label)
		
	p2_buttons = [
		$HBoxContainer/UpgradePlayer2/ButtonShield2,
		$HBoxContainer/UpgradePlayer2/ButtonReactor2,
		$HBoxContainer/UpgradePlayer2/ButtonCondensator2,
		$HBoxContainer/UpgradePlayer2/ButtonAccumulor2
	]
	
	#var player2_manager = PlayerManager.new(p2_buttons, "ui_up_p1", "ui_down_p1", $Joueur1/Label)
		
	# Focus initial
	p1_buttons[0].grab_focus()
	p2_buttons[0].grab_focus()
	
func _input(event):
	if event.is_action_pressed("move_down"):
		p1_index = (p1_index + 1) % p1_buttons.size()
		update(p1_buttons, p1_index)
	elif event.is_action_pressed("move_up"):
		p1_index = (p1_index - 1) % p1_buttons.size()
		update(p1_buttons, p1_index)

	if event.is_action_pressed("move_down_2"):
		p2_index = (p2_index + 1) % p2_buttons.size()
		update(p2_buttons, p2_index)
	elif event.is_action_pressed("move_up_2"):
		p2_index = (p2_index - 1) % p2_buttons.size()
		update(p2_buttons, p2_index)
	
	print(p1_index, p2_index)

func update(buttons : Array, index_selected: int):
	# Réinitialiser tous les boutons
	for i in range(buttons.size()):
		buttons[i].modulate = Color.WHITE
	
	# Mettre en évidence le bouton sélectionné
	buttons[index_selected].modulate = Color.YELLOW

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
