extends KinematicBody2D

var bombScene = preload("res://scenes/Bomba.tscn")
var vel = Vector2.ZERO
var can_fire = true
var speed = -5000
var robot_shooted = false

onready var playerPositionX = get_tree().get_nodes_in_group("player")[0].global_position.x
onready var screen_shaker = get_parent().get_node("ParallaxBackground/GameCamera/shaker")

func _ready():
	set_as_toplevel(true)

func _process(delta):
	playerPositionX = get_tree().get_nodes_in_group("player")[0].global_position.x
	if global_position.x  <= playerPositionX and can_fire:
		speed = -2500
		var bombInstance = bombScene.instance()
		get_parent().add_child(bombInstance)
		bombInstance.global_position = $Sprite.global_position
		can_fire = false

	vel.x = speed * delta
	vel = move_and_slide(vel)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_fireTimer_timeout():
	var bombInstance = bombScene.instance()
	get_parent().add_child(bombInstance)
	bombInstance.global_position = $Sprite.global_position
	screen_shaker.shake(0.1, 2)
	$fireTimer.start()

func _on_RobotHazardArea_area_entered(area):
	if area.get_name().begins_with("Bullet") or area.get_name().begins_with("@Bullet"):
		queue_free()
