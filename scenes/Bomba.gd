extends Area2D

export var speed = 100
var robot_shooted = false
var bomba = true

func _ready():
	set_as_toplevel(true)

func _physics_process(delta):
	position += (Vector2.DOWN * speed).rotated(rotation) * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Bomba_area_entered(area):
	if area.get_name() == "HazardArea":
		visible = false
