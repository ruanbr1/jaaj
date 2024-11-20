extends CanvasLayer


func _on_BtnVoltar_pressed():
	$"/root/ScreenTransitionManager".transition_to_scene("res://scenes/MainMenu.tscn")
