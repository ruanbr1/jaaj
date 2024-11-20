extends Button


func _ready():
	pass

func _process(_delta):
	rect_pivot_offset = rect_min_size / 2

func _on_AnimatedButton_mouse_entered():
	$Select2.play()
	$HoverAnimationPlayer.play("hover")

func _on_AnimatedButton_mouse_exited():
	$HoverAnimationPlayer.play_backwards("hover")

func _on_AnimatedButton_pressed():
	$Select.play()
	$ClickAnimationPlayer.play("click")
