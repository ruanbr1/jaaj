extends CanvasLayer


func _ready():
	pass

func _on_PlayButton_pressed():
	$"/root/ScreenTransitionManager".transition_to_scene("res://scenes/UI/Controles.tscn")

func _on_SairButton_pressed():
	get_tree().quit()

func _on_BtnCreditos_pressed():
	$"/root/ScreenTransitionManager".transition_to_scene("res://scenes/UI/Creditos.tscn")
