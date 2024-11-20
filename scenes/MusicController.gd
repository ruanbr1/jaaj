extends Node

var is_playing = false

func _ready():
	pass

func _process(_delta):
	if get_tree().current_scene.name == "MainMenu" or get_tree().current_scene.name == "Creditos" or get_tree().current_scene.name == "Controles":
		if !is_playing:
			is_playing = true
			$"Menu Rose".playing = true
	else:
		is_playing = false
		$"Menu Rose".playing = false
