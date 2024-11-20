extends CanvasLayer


func _ready():
	pass

func _on_BtnOk_pressed():
	$"/root/ScreenTransitionManager".transition_to_scene("res://scenes/World.tscn")
