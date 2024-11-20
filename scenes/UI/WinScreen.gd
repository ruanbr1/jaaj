extends CanvasLayer

onready var score = get_tree().get_nodes_in_group("world")[0].score
onready var level = get_tree().get_nodes_in_group("world")[0].playerLevel
onready var sofrido = get_tree().get_nodes_in_group("world")[0].sofrido

func _ready():
	get_tree().paused = true
	var um = str("Voce completou todo o jogo, passou por ", level, " levels,")
	var dois = str(" sofreu ", sofrido, " de dano")
	var tres = str(" e ganhou ", score, " de score em sua longa jornada, parabens e muito obrigado por jogar o meu jogo!")
	$MarginContainer/CenterContainer/VBoxContainer/Label2.text = um + dois + tres

func unpause():
	queue_free()
	get_tree().paused = false

func _on_BtnVoltar_pressed():
	var _recarregar_cena = get_tree().reload_current_scene()
	unpause()

func _on_BtnMenu_pressed():
	unpause()
	var _trocar_cena = get_tree().change_scene("res://scenes/MainMenu.tscn")

