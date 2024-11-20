extends Node2D

signal player_died
signal powerup
signal finalSpawn

var pauseScene = preload("res://scenes/PauseMenu.tscn")
var winScene = preload("res://scenes/UI/WinScreen.tscn")
var gameoverScene = preload("res://scenes/UI/Gameover.tscn")

var maxLevel = 100

var playerScene = preload("res://scenes/Player.tscn")
var vidaPlayer = 50
var damage_player = 0
var spawnPosition = null
var currentPlayerNode = null
export(int) var playerLevel = 0
var score = 0
var weapons = null
var weapon = null
var powerupAudioPlayed = false
var sofrido = 0

signal enemy_died

var enemyScene = preload("res://scenes/Enemy.tscn")
var vidaInimigo = 50
var damage_inimigo = 0
var enemySpawnPosition = null
var currentEnemyNode = null
export(int) var enemyLevel = 0

var robotScene = preload("res://scenes/Robot.tscn")
var robotBombScene = preload("res://scenes/RoboBomba.tscn")
var robotBlueScene = preload("res://scenes/RobotBlue.tscn")

func _ready():
	spawnPosition = $Player.global_position
	enemySpawnPosition = $Enemy.global_position
	register_player($Player)
	register_enemy($Enemy)
	$RobotSpawnTimer.start()

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		var pauseInstance = pauseScene.instance()
		add_child(pauseInstance)

func register_player(player):
	currentPlayerNode = player
	currentPlayerNode.connect("damage", self, "on_player_damage")
	currentPlayerNode.get_node("Gun").connect("shooted", self, "on_player_shooted")
	vidaPlayer = 50

func create_player():
	var playerInstance = playerScene.instance()
	add_child_below_node(currentPlayerNode, playerInstance)
	playerInstance.global_position = spawnPosition
	register_player(playerInstance)
	currentPlayerNode.get_node("AnimationPlayer").play("spawnBlink")
	yield(currentPlayerNode.get_node("AnimationPlayer"), "animation_finished")
	currentPlayerNode.get_node("AnimationPlayer").play("run")

func on_player_damage(area):
	if area.get_name().begins_with("Bullet") or area.get_name().begins_with("@Bullet"):
		if area.robot_shooted:
			vidaPlayer -= 10
			sofrido += 10
	if area.get_name().begins_with("Bomba") or area.get_name().begins_with("@Bomba"):
		vidaPlayer -= 15
		sofrido += 15
		currentPlayerNode.get_node("bomba").play()
	if area.get_name().begins_with("RobotBlue") or area.get_name().begins_with("@RobotBlue"):
		vidaPlayer -= 13
		sofrido += 13
	

	vidaPlayer -= damage_inimigo
	sofrido += damage_inimigo
	currentPlayerNode.get_node("hit").play()
	if vidaPlayer <= 0:
		currentPlayerNode.visible = false
		call_deferred("disable_player_collisions")
		emit_signal("player_died")
		$SpawnTimer.start()
		yield($SpawnTimer, "timeout")
		enemyLevel += 1
		score -= 300
		playerLevel -= 1
		currentPlayerNode.queue_free()
		create_player()

func new_powerup():
	emit_signal("powerup", playerLevel)
	powerupAudioPlayed = false

func register_enemy(enemy):
	currentEnemyNode = enemy
	currentEnemyNode.connect("damage", self, "on_enemy_damage")
	currentEnemyNode.get_node("Gun").connect("shooted", self, "on_enemy_shooted")
	vidaInimigo = 50

func create_enemy():
	var enemyInstance = enemyScene.instance()
	add_child_below_node(currentEnemyNode, enemyInstance)
	enemyInstance.global_position = enemySpawnPosition
	register_enemy(enemyInstance)
	currentEnemyNode.get_node("AnimationPlayer").play("spawnBlink")
	yield(currentEnemyNode.get_node("AnimationPlayer"), "animation_finished")
	currentEnemyNode.get_node("AnimationPlayer").play("run")

func on_enemy_damage():
	vidaInimigo -= damage_player
	currentEnemyNode.get_node("hit").play()
	if vidaInimigo <= 0:
		emit_signal("enemy_died")
		currentEnemyNode.visible = false
		call_deferred("disable_enemy_collisions")
		$EnemySpawnTimer.start()
		yield($EnemySpawnTimer, "timeout")
		currentEnemyNode.queue_free()
		playerLevel += 1
		score += 200
		if playerLevel < 95:
			if enemyLevel > 6 and enemyLevel < 10:
				enemyLevel -= 1
			if enemyLevel <= playerLevel / 2:
				enemyLevel += 1
			if enemyLevel <= playerLevel - 3:
				enemyLevel += 1
		new_powerup()
		create_enemy()

func on_player_shooted(damage):
	if weapon == weapons[5]:
		currentPlayerNode.get_node("tiro_bazuca").play()
	if weapon == weapons[6]:
		currentPlayerNode.get_node("laser").play()
	else:
		currentPlayerNode.get_node("tiro").play()
	damage_player = damage

func on_enemy_shooted(damage):
	if enemyLevel >= 25 and enemyLevel < 30:
		currentEnemyNode.get_node("tiro_bazuca").play()
	elif enemyLevel >= 30 and enemyLevel < 35:
		currentEnemyNode.get_node("laser").play()
	else:
		currentEnemyNode.get_node("tiro").play()
	damage_inimigo = damage

func _process(_delta):
	$GameUI/playerHealth.value = vidaPlayer * 2
	$GameUI/enemyHealth.value = vidaInimigo * 2
	$GameUI/PlayerStatus/VBoxContainer/Label2.text = str("Level ", playerLevel)
	$GameUI/EnemyStatus/VBoxContainer/Label2.text = str("Level ", enemyLevel)
	score += 0.4
	$GameUI/Score/Label.text = str("Score: ", round(score))
	
	if playerLevel % 5 == 0:
		if !powerupAudioPlayed:
			if playerLevel > 0:
				powerupAudioPlayed = true
				currentPlayerNode.get_node("powerup").play()
	
	if playerLevel >= maxLevel:
		var winInstance = winScene.instance()
		add_child(winInstance)
		
	if playerLevel < 0 or score < 0:
		score -= 20
		var gameoverInstance = gameoverScene.instance()
		add_child(gameoverInstance)

	if playerLevel < 100 and enemyLevel >= 100:
		var gameoverInstance = gameoverScene.instance()
		add_child(gameoverInstance)

	load_icons()
	
	if playerLevel >= 95 and playerLevel < 100:
		if get_tree().get_nodes_in_group("Robot").size() < 3:
			if get_tree().get_nodes_in_group("Robot").size() < 3:
				var robotInstance = robotScene.instance()
				add_child_below_node(currentEnemyNode, robotInstance)
				robotInstance.global_position = Vector2(255, rand_range(119, 60))
		if get_tree().get_nodes_in_group("RoboBomba").size() <= 0:
			if get_tree().get_nodes_in_group("RoboBomba").size() <= 0:
				var robotBombInstance = robotBombScene.instance()
				add_child_below_node(currentEnemyNode, robotBombInstance)
				robotBombInstance.global_position = Vector2(255, 50)

func disable_player_collisions():
	currentPlayerNode.get_node("HazardArea/CollisionShape2D").disabled = true

func disable_enemy_collisions():
	currentEnemyNode.get_node("HazardArea/CollisionShape2D").disabled = true

func _on_RobotSpawnTimer_timeout():
	randomize()
	var robos = ["Rred", "Rdark", "Rblue"]
	var sorteio = robos[randi() % robos.size()]
	print(sorteio)
	
	if sorteio == "Rred":
		for _i in range(rand_range(1, 2)):
			var robotInstance = robotScene.instance()
			add_child_below_node(currentEnemyNode, robotInstance)
			robotInstance.global_position = Vector2(255, rand_range(119, 60))
	elif sorteio == "Rdark":
		var robotBombInstance = robotBombScene.instance()
		add_child_below_node(currentEnemyNode, robotBombInstance)
		robotBombInstance.global_position = Vector2(255, 50)
	elif sorteio == "Rblue":
		var robotBlueInstance = robotBlueScene.instance()
		add_child_below_node(currentEnemyNode, robotBlueInstance)
		robotBlueInstance.global_position = Vector2(255, 140)

func load_icons():
	if currentPlayerNode != null:
		weapons = currentPlayerNode.weapons
		weapon = currentPlayerNode.weapon
	
	if !Input.is_action_pressed("pick"):
		exibir_powerup(1, 5, 10, $GameUI/PlayerPowerUps/SubMetralha)
		exibir_powerup(2, 10, 15, $GameUI/PlayerPowerUps/Andre)
		exibir_powerup(3, 15, 20, $GameUI/PlayerPowerUps/Magnum)
		exibir_powerup(4, 20, 25, $GameUI/PlayerPowerUps/ShotR)
		exibir_powerup(5, 25, 30, $GameUI/PlayerPowerUps/Bazuca)
		exibir_powerup(6, 30, 35, $GameUI/PlayerPowerUps/Laser)
		exibir_powerup(7, 35, 40, $GameUI/PlayerPowerUps/Arco)
		exibir_powerup(8, 40, 45, $GameUI/PlayerPowerUps/Watergun)
		exibir_powerup(9, 45, 50, $GameUI/PlayerPowerUps/Fireball)
		exibir_powerup(10, 50, 55, $GameUI/PlayerPowerUps/Paintball)
		exibir_powerup(11, 55, 60, $GameUI/PlayerPowerUps/Mago)
		exibir_powerup(12, 60, 65, $GameUI/PlayerPowerUps/Granada)
		exibir_powerup(13, 65, 70, $GameUI/PlayerPowerUps/Marreta)
		exibir_powerup(14, 70, 75, $GameUI/PlayerPowerUps/Desert)
		exibir_powerup(15, 75, 80, $GameUI/PlayerPowerUps/Axe)
		exibir_powerup(16, 80, 85, $GameUI/PlayerPowerUps/Mosquete)
		exibir_powerup(17, 85, 90, $GameUI/PlayerPowerUps/Ppsh)
		exibir_powerup(18, 90, 95, $GameUI/PlayerPowerUps/Bomba)
		exibir_powerup(19, 95, 100, $GameUI/PlayerPowerUps/Minigun)

func exibir_powerup(index, levelMinimo, levelMaximo, UINode):
	if weapon != weapons[index]:
		if playerLevel != null:
			if playerLevel >= levelMinimo and playerLevel < levelMaximo:
				UINode.visible = true
			else:
				UINode.visible = false
	else:
		UINode.visible = false

func _on_FinalSpawn_timeout():
	emit_signal("finalSpawn")
