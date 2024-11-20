extends Camera2D

export(Color, RGB) var BackgroundColor

var time  = 0

func _ready():
	VisualServer.set_default_clear_color(BackgroundColor)
	zoom = Vector2(0.5, 0.5)
