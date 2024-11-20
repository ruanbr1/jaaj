extends CanvasLayer

func _ready():
	get_tree().paused = true

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		unpause()
		get_tree().set_input_as_handled()

func unpause():
	queue_free()
	get_tree().paused = false

func _on_BtnVoltar_pressed():
	unpause()

func _on_BtnMenu_pressed():
	$"/root/ScreenTransitionManager".transition_to_scene("res://scenes/MainMenu.tscn")
	unpause()
