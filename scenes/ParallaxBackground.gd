extends ParallaxBackground

export(int) var scroll_speed = 500

func _process(delta):
	scroll_base_offset.x += scroll_speed * delta
