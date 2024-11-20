extends CanvasLayer

onready var score = get_tree().get_nodes_in_group("world")[0].score
onready var level = get_tree().get_nodes_in_group("world")[0].playerLevel

var texto = "VOCE PERDEU O JOGO"

func _ready():
	get_tree().paused = true
	if level > 0 and score > 0:
		texto = "O INIMIGO CHEGOU AO LEVEL MAXIMO ANTES DE VOCE"

	$MarginContainer/CenterContainer/VBoxContainer/Label2.text = texto
	$MarginContainer/CenterContainer/VBoxContainer/Label3.text = str("SCORE: ", score)

func unpause():
	queue_free()
	get_tree().paused = false

func _on_BtnVoltar_pressed():
	var _recarregar_cena = get_tree().reload_current_scene()
	unpause()

func _on_BtnMenu_pressed():
	get_tree().paused = false
	var _trocar_cena = get_tree().change_scene("res://scenes/MainMenu.tscn")
