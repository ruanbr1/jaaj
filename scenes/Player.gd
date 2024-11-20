extends KinematicBody2D

signal damage

export(String) var Personagem = "res://scenes/Player.tres"

onready var screen_shaker = get_parent().get_node("ParallaxBackground/GameCamera/shaker")
var vel = Vector2.ZERO
var gravity = 1000
var jumpForce = 360
var jumpMultiplier = 3
onready var weapons = ["shot", "subM", "amdre", "magnum", "shot_rapida", "bazuca", "laser", "arco", "watergun", "fireball", "paintball", "mago", "granada", "bionica", "desert", "axe", "musket", "ppsh", "bomba", "minigun"]
onready var weapon = weapons[0]
onready var level = get_tree().get_nodes_in_group("world")[0].playerLevel

func _ready():
	$AnimatedSprite.frames = load(Personagem)

func _process(delta):
	var moveVector = get_movement_vector()

	if moveVector.y < 0 && is_on_floor():
		vel.y = moveVector.y * jumpForce
		
	if vel.y < 0 && !Input.is_action_pressed("jump"):
		vel.y += gravity * jumpMultiplier * delta
	else:
		vel.y += gravity * delta

	vel = move_and_slide(vel, Vector2.UP)

	var direction = sign(get_global_mouse_position().x - global_position.x)
	
	if direction < 0:
		$AnimatedSprite.flip_h = true
		$Gun.scale.y = -1
	else:
		$AnimatedSprite.flip_h = false
		$Gun.scale.y = 1
		
	load_weapons()

func get_movement_vector():
	var moveVector = Vector2.ZERO
	moveVector.y = -1 if Input.is_action_just_pressed("jump") else 0
	
	return moveVector

func _on_HazardArea_area_entered(area):
	emit_signal("damage", area)
	$AnimationPlayer.play("blink")
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("run")

func load_weapons():
	level = get_tree().get_nodes_in_group("world")[0].playerLevel
	if Input.is_action_pressed("pick"):
		#Muda as propriedades das armas conforme o index
		mudar_armas(0, "res://assets/weapons/shotgun.png", 1.5, 20)
		mudar_armas(1, "res://assets/weapons/submetralha.png", 0.3, 6)
		mudar_armas_e_skin(2, "res://scenes/Andre.tres", "res://assets/weapons/colher.png", 0.7, 9)
		mudar_armas(3, "res://assets/weapons/magnum.png", 0.6, 10)
		mudar_armas(4, "res://assets/weapons/shotgun_rapida.png", 1, 15)
		mudar_armas(5, "res://assets/weapons/bazuca.png", 3, 25)
		mudar_armas(6, "res://assets/weapons/laser.png", 0.9, 15)
		mudar_armas(7, "res://assets/weapons/arco.png", 1.1, 11)
		mudar_armas(8, "res://assets/weapons/watergun.png", 0.5, 5)
		mudar_armas(9, "res://assets/weapons/fireball.png", 1, 20)
		mudar_armas(10, "res://assets/weapons/paintball.png", 0.9, 9)
		mudar_armas(11, "res://assets/weapons/mago.png", 1.2, 18)
		mudar_armas(12, "res://assets/weapons/granada.png", 1, 14)
		mudar_armas(13, "res://assets/weapons/bionica.png", 0.8, 7)
		mudar_armas(14, "res://assets/weapons/desert_eagle.png", 0.6, 12)
		mudar_armas(15, "res://assets/weapons/axe.png", 0.4, 3)
		mudar_armas(16, "res://assets/weapons/musket.png", 1.5, 20)
		mudar_armas(17, "res://assets/weapons/ppsh.png", 0.3, 7)
		mudar_armas(18, "res://assets/bullets/bomba.png", 0.7, 10)
		mudar_armas(19, "res://assets/weapons/minigun.png", 0.1, 15)

		#Muda os powerups
		mudar_levels(5, 10, 1)
		mudar_levels(10, 15, 2)
		mudar_levels(15, 20, 3)
		mudar_levels(20, 25, 4)
		mudar_levels(25, 30, 5)
		mudar_levels(30, 35, 6)
		mudar_levels(35, 40, 7)
		mudar_levels(40, 45, 8)
		mudar_levels(45, 50, 9)
		mudar_levels(50, 55, 10)
		mudar_levels(55, 60, 11)
		mudar_levels(60, 65, 12)
		mudar_levels(65, 70, 13)
		mudar_levels(70, 75, 14)
		mudar_levels(75, 80, 15)
		mudar_levels(80, 85, 16)
		mudar_levels(85, 90, 17)
		mudar_levels(90, 95, 18)
		mudar_levels(95, 100, 19)

func mudar_armas(index, assetArma, tempoRecarga, dano):
	if weapon == weapons[index]:
		$Gun.Arma = assetArma
		$Gun/fireTimer.wait_time = tempoRecarga
		$Gun.damage = dano

func mudar_armas_e_skin(index, personagem, assetArma, tempoRecarga, dano):
	if weapon == weapons[index]:
		Personagem = personagem
		$AnimatedSprite.frames = load(Personagem)
		$Gun.Arma = assetArma
		$Gun/fireTimer.wait_time = tempoRecarga
		$Gun.damage = dano

func mudar_levels(minimo, maximo, index):
	if level >= minimo and level < maximo:
		weapon = weapons[index]
