extends Control


func _on_AnimationPlayer_animation_finished(_anim_name):
	$"/root/ScreenTransitionManager".transition_to_scene("res://scenes/MainMenu.tscn")
