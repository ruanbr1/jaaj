extends Node

var screenTransitionScene = preload("res://scenes/ScreenTransition.tscn")

func transition_to_scene(scenePath):
	get_tree().paused = false
	var screenTransition = screenTransitionScene.instance()
	add_child(screenTransition)
	yield(screenTransition, "screen_covered")
	var _trocar_cena = get_tree().change_scene(scenePath)
