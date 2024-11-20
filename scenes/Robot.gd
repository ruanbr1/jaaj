extends KinematicBody2D

onready var screen_shaker = get_parent().get_node("ParallaxBackground/GameCamera/shaker")
var bulletScene = preload("res://scenes/Bullet.tscn")
var can_fire = true
var vel = Vector2.ZERO
var speed = -5500
var damage = 10

func _ready():
	set_as_toplevel(true)
	$MoveTimer.start()

func _process(_delta):
	if get_tree().get_nodes_in_group("player").size() > 0:
		look_at(get_tree().get_nodes_in_group("player")[0].global_position)

	vel = move_and_slide(vel)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_MoveTimer_timeout():
	vel.y = speed * get_process_delta_time()
	can_fire = false
	$DeathTimer.start()

func _on_fireTimer_timeout():
	if can_fire:
		var bulletInstance = bulletScene.instance()
		get_parent().add_child(bulletInstance)
		bulletInstance.global_rotation = global_rotation
		screen_shaker.shake(0.1, 2)
		bulletInstance.global_position = $Sprite.global_position
		bulletInstance.robot_shooted = true
		$tiro.play()
		$fireTimer.start()

func _on_HazardArea_area_entered(area):
	if area.get_name().begins_with("Bullet") or area.get_name().begins_with("@Bullet"):
		if !area.robot_shooted:
			queue_free()

func _on_DeathTimer_timeout():
	queue_free()
