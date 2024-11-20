extends KinematicBody2D

var vel = Vector2.ZERO
var can_fire = true
var speed = -5000
var robot_shooted = false

func _ready():
	set_as_toplevel(true)

func _process(delta):
	vel.x = speed * delta
	vel = move_and_slide(vel)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_RobotHazardArea_area_entered(area):
	if area.get_name().begins_with("Bullet") or area.get_name().begins_with("@Bullet"):
		if area.enemy_shooted == false and area.robot_shooted == false:
			queue_free()
