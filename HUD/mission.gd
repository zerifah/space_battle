extends CanvasLayer

@onready var mission_text = $MissionText
@onready var mission_title= $Title
@onready var level1 = preload("res://levels/level_1.tscn")
@onready var level2 = preload("res://levels/level_2.tscn")
@onready var next_level = level1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print('Mission initialié pour le niveau ', Settings.level)
	var msg = ''
	if Settings.level == 1 :
		msg = prepare_message_1()
	elif Settings.level == 2 :
		msg = prepare_message_2()
		next_level = level2
		
	mission_title.text ='Mission '+ str(Settings.level)
	mission_text.text = msg

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
	
func _on_button_ok_pressed() -> void:
	get_tree().change_scene_to_packed(next_level)

func prepare_message_1() ->String:
	var plural = Settings.two_players
	var msg : String=''
	
	if plural :
		msg = 'Jeunes pilotes!'
	else :
		msg = 'Jeune pilote!'
	
	msg += '\nNous avons absolument besoin de '
	
	if plural :
		msg += 'vous !'
	else :
		msg += 'toi !'
	
	msg += "\nNous n'avons plus assez de pilotes expérimenté·es pour repousser \
		les mystérieuses vagues de météorites qui semblent vouloir détruire notre planète!\n"
	
	if plural :
		msg += 'Votre'
	else :
		msg += 'ta'
	
	msg += " formation n'est pas terminée, mais comme "
	
	if plural :
		msg += 'vous avez'
	else :
		msg += 'tu as'
	
	msg += "  montré d'excellentes compétences dans les simulateurs de vol, nous "
	
	if plural :
		msg += 'vous'
	else :
		msg += "t'"
	
	msg += " avons selectionné·e"
	
	if plural :
		msg += "s"
		
	msg += " pour prendre les commandes d'un vrai vaisseau de chasse! \
		Il faut absolument détruire les météorites avant qu'elles ne détruisent notre\
		planète!\n\n"
		
	if plural :
		msg += "Acceptez-vous la mission que nous vous proposons ?"
	else :
		msg += 'Acceptes-tu la mission que nous te proposons ?'
	
	return msg

func prepare_message_2() ->String:
	var msg = "Félicitations!\n\nVous avez été à la hauteur de nos attentes! \
		Entre temps, dans les débris des astréroides, nous avons découvert un \
		minerai rare! Celui-ci ne se trouve que dans la ceinture d'asteroides de \
		Poychish2582.\n\n \
		Nous pensons qu'il est urgent que nous allions voir là-bas ce qu'il se passe. \
		Il nous faut pour cela nos meilleur·es pilotes! Ce sera périlleux de la traverser \
		sans entrer en collision avec les astéroides. Le moindre faux pas est fatal!\n \
		Acceptez-vous de vous-y rendre?"
	
	return msg
