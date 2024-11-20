extends Sprite

signal shooted

export(String) var Arma = "res://assets/weapons/shotgun.png"

var can_fire = true
var bulletScene = preload("res://scenes/Bullet.tscn")
export(int) var damage = 10
onready var weapons = ["shot", "subM", "amdre", "magnum", "shot_rapida", "bazuca", "laser", "arco", "watergun", "fireball", "paintball", "mago", "granada", "bionica", "desert", "axe", "musket", "ppsh", "bomba", "minigun"]
onready var enemyWeapon = get_tree().get_nodes_in_group("enemy")[0].weapon

func _ready():
	get_tree().get_nodes_in_group("world")[0].connect("enemy_died", self, "on_enemy_died")
	
func _process(_delta):
	enemyWeapon = get_tree().get_nodes_in_group("enemy")[0].weapon
	texture = load(Arma)
	if get_tree().get_nodes_in_group("player").size() > 0:
		look_at(get_tree().get_nodes_in_group("player")[0].global_position)

func _on_fireTimer_timeout():
	if can_fire:
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
		get_parent().screen_shaker.shake(0.01, 2)
		bulletInstance.global_position = $Position2D.global_position
		bulletInstance.enemy_shooted = true
		emit_signal("shooted", damage)

func mudar_asset_bala(weaponIndex, bulletInstance, asset):
	if enemyWeapon == weapons[weaponIndex]:
		bulletInstance.asset = asset

func modulate_bala(weaponIndex, cor, bulletInstance):
	if enemyWeapon == weapons[weaponIndex]:
		bulletInstance.get_node("Sprite").modulate = cor

func on_enemy_died():
	can_fire = false
