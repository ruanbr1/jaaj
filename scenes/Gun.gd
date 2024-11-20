extends Sprite

signal shooted

export(String) var Arma = "res://assets/weapons/shotgun.png"

var can_fire = true
var bulletScene = preload("res://scenes/Bullet.tscn")
export(int) var damage = 10
onready var weapons = ["shot", "subM", "amdre", "magnum", "shot_rapida", "bazuca", "laser", "arco", "watergun", "fireball", "paintball", "mago", "granada", "bionica", "desert", "axe", "musket", "ppsh", "bomba", "minigun"]
onready var playerWeapon = get_tree().get_nodes_in_group("world")[0].weapon

func _ready():
	get_tree().get_nodes_in_group("world")[0].connect("player_died", self, "on_player_died")

func _physics_process(delta):
	texture = load(Arma)
	
	global_position.x = lerp(get_parent().global_position.x, global_position.x, pow(2, -.5 * delta))
	global_position.y = lerp(get_parent().global_position.y, global_position.y, pow(2, -.5 * delta))
	look_at(get_global_mouse_position())

func _input(event):
	if event.is_action_pressed("fire"):
		playerWeapon = get_tree().get_nodes_in_group("world")[0].weapon
		if can_fire:
			$fireTimer.start()
			var bulletInstance = bulletScene.instance()
			
			mudar_asset_bala(5, bulletInstance, "res://assets/bullets/tiro_bazuca.png")
			modulate_bala(6, Color.aqua, bulletInstance)
			mudar_asset_bala(7, bulletInstance, "res://assets/bullets/tiro_arco.png")
			mudar_asset_bala(8, bulletInstance, "res://assets/bullets/tiro_dagua.png")
			mudar_asset_bala(9, bulletInstance, "res://assets/weapons/fireball.png")
			mudar_asset_bala(10, bulletInstance, "res://assets/bullets/tiro_dagua.png")
			modulate_bala(10, Color(randf(), randf(), randf()), bulletInstance)
			mudar_asset_bala(11, bulletInstance, "res://assets/bullets/tiro_mago.png")
			mudar_asset_bala(12, bulletInstance, "res://assets/bullets/granada.png")
			mudar_asset_bala(13, bulletInstance, "res://assets/bullets/bionica.png")
			mudar_asset_bala(15, bulletInstance, "res://assets/bullets/axe.png")
			mudar_asset_bala(18, bulletInstance, "res://assets/bullets/bomba2.png")
			
			get_parent().add_child(bulletInstance)
			bulletInstance.global_rotation = global_rotation
			get_parent().screen_shaker.shake(0.09, 2)
			bulletInstance.global_position = $Position2D.global_position
			can_fire = false
			emit_signal("shooted", damage)

func mudar_asset_bala(weaponIndex, bulletInstance, asset):
	playerWeapon = get_tree().get_nodes_in_group("world")[0].weapon
	if playerWeapon == weapons[weaponIndex]:
		bulletInstance.asset = asset

func modulate_bala(weaponIndex, cor, bulletInstance):
	playerWeapon = get_tree().get_nodes_in_group("world")[0].weapon
	if playerWeapon == weapons[weaponIndex]:
		bulletInstance.modulate = cor

func _on_fireTimer_timeout():
	can_fire = true

func on_player_died():
	$fireTimer.stop()
	can_fire = false
