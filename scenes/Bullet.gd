extends Area2D

export(String) var asset = "res://assets/bullets/tiro.png"
export var speed = 500
var robot_shooted = false
var enemy_shooted = false

func _ready():
	set_as_toplevel(true)

func _physics_process(delta):
	$Sprite.texture = load(asset)
	position += (Vector2.RIGHT * speed).rotated(rotation) * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
