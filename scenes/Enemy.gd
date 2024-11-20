extends KinematicBody2D

signal damage

export(String) var Personagem = "res://scenes/Enemy.tres"

onready var screen_shaker = get_parent().get_node("ParallaxBackground/GameCamera/shaker")
var vel = Vector2.ZERO
var gravity = 1000
var jumpForce = 360
var weapons = ["shot", "subM", "amdre", "magnum", "shot_rapida", "bazuca", "laser", "arco", "watergun", "fireball", "paintball", "mago", "granada", "bionica", "desert", "axe", "musket", "ppsh", "bomba", "minigun"]
var weapon = weapons[0]
onready var level = get_tree().get_nodes_in_group("world")[0].enemyLevel

func _ready():
	$AnimatedSprite.frames = load(Personagem)

func _process(delta):
	vel.y += gravity * delta
	vel = move_and_slide(vel, Vector2.UP)
	load_weapons()

func _on_JumpTimer_timeout():
	$JumpTimer.wait_time = rand_range(7, 12)
	if is_on_floor():
		vel.y = -jumpForce
	$JumpTimer.start()

func _on_HazardArea_area_entered(_area):
	emit_signal("damage")
	$AnimationPlayer.play("blink")
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("run")

func load_weapons():
	level = get_tree().get_nodes_in_group("world")[0].enemyLevel
	#Muda as propriedades das armas conforme o index
	mudar_armas(5, 10, 1, "res://assets/weapons/submetralha.png", 0.3, 6)
	mudar_armas_e_skin(10, 15, 2, "res://scenes/Andre.tres", "res://assets/weapons/colher.png", 0.7, 9)
	mudar_armas(15, 20, 3, "res://assets/weapons/magnum.png", 0.6, 10)
	mudar_armas(20, 25, 4, "res://assets/weapons/shotgun_rapida.png", 1, 15)
	mudar_armas(25, 30, 5, "res://assets/weapons/bazuca.png", 3, 25)
	mudar_armas(30, 35, 6, "res://assets/weapons/laser.png", 0.9, 15)
	mudar_armas(35, 40, 7, "res://assets/weapons/arco.png", 1.1, 11)
	mudar_armas(40, 45, 8, "res://assets/weapons/watergun.png", 0.5, 5)
	mudar_armas(45, 50, 9, "res://assets/weapons/fireball.png", 1, 20)
	mudar_armas(50, 55, 10, "res://assets/weapons/paintball.png", 0.9, 9)
	mudar_armas(55, 60, 11, "res://assets/weapons/mago.png", 1.2, 18)
	mudar_armas(60, 65, 12, "res://assets/weapons/granada.png", 1, 14)
	mudar_armas(65, 70, 13, "res://assets/weapons/bionica.png", 0.8, 7)
	mudar_armas(70, 75, 14, "res://assets/weapons/desert_eagle.png", 0.6, 12)
	mudar_armas(75, 80, 15, "res://assets/weapons/axe.png", 0.4, 3)
	mudar_armas(80, 85, 16, "res://assets/weapons/musket.png", 1.5, 20)
	mudar_armas(85, 90, 17, "res://assets/weapons/ppsh.png", 0.3, 7)
	mudar_armas(90, 95, 18, "res://assets/bullets/bomba.png", 0.7, 10)
	mudar_armas(95, 100, 19,"res://assets/weapons/minigun.png", 0.25, 15)

func mudar_armas(levelMinimo,levelMaximo, index, assetArma, tempoRecarga, dano):
	if level >= levelMinimo and level < levelMaximo:
		weapon = weapons[index]
		$Gun.Arma = assetArma
		$fireTimer.wait_time = tempoRecarga
		$Gun.damage = dano

func mudar_armas_e_skin(levelMinimo, levelMaximo, index, _personagem, assetArma, tempoRecarga, dano):
	if level >= levelMinimo and level < levelMaximo:
		weapon = weapons[index]
		$AnimatedSprite.play("andre")
		$Gun.Arma = assetArma
		$fireTimer.wait_time = tempoRecarga
		$Gun.damage = dano
