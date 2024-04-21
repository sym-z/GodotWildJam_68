extends Node2D
var bullet_scene = preload("res://Scenes/projectile.tscn")
var boss_scene = preload("res://Scenes/boss.tscn")
var screen_bullets = []
var projectile_speed : float = 200.0
var pre_boss : bool = true
var total_enemies : int
# Called when the node enters the scene tree for the first time.
func _ready():
	$Camera2D.position = $"Rooms/Room 1/Cam Marker".position
	
	var enemies = $Enemies.get_children()
	total_enemies = enemies.size()
	for x in enemies:
		if x.has_method("damage"):
			x.player = $Iron_Shell;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $"Camera2D/Crafting Menu".visible == true:
		$"Hud/Hud Background".frame = 3
	else:
		if $Iron_Shell.shield_unlocked:
			$"Hud/Hud Background".frame = 2
		elif $Iron_Shell.hammer_unlocked:
			$"Hud/Hud Background".frame = 1
		else:
			$"Hud/Hud Background".frame = 0
	total_enemies = 0
	var enemies = $Enemies.get_children()
	for x in enemies:
		if x.has_method("damage"):
			total_enemies += 1
	if total_enemies == 0 && pre_boss == true:
		pre_boss = false;
		# Spawn Boss
		var boss = boss_scene.instantiate()
		boss.player = $Iron_Shell
		add_child(boss)
		boss.global_position = $"Boss Spawn Point".global_position
		
	# Change the frames to be the correct number for my coal, iron, gold, and copper
	$"Hud/Numbers/Coal Count/Coal Ten".frame = floor($Iron_Shell.coal_count / 10)
	$"Hud/Numbers/Coal Count/Coal One".frame = $Iron_Shell.coal_count % 10
	
	$"Hud/Numbers/Gold Count/Gold Ten".frame = floor($Iron_Shell.gold_count / 10)
	$"Hud/Numbers/Gold Count/Gold One".frame = $Iron_Shell.gold_count % 10
	
	$"Hud/Numbers/Iron Count/Iron Ten".frame = floor($Iron_Shell.iron_count / 10)
	$"Hud/Numbers/Iron Count/Iron One".frame =  $Iron_Shell.iron_count % 10
	
	$"Hud/Numbers/Copper Count/Copper Ten".frame = floor($Iron_Shell.copper_count / 10)
	$"Hud/Numbers/Copper Count/Copper One".frame = $Iron_Shell.copper_count % 10
	
	

func _on_shoot():
	var bullet = bullet_scene.instantiate()
	var dir : Vector2
	add_child(bullet)
	bullet.position = $Iron_Shell.global_position
	match $Iron_Shell.facing:
		0:
			dir = Vector2.LEFT
		2:
			dir = Vector2.RIGHT
		4:
			dir = Vector2.UP
		8:
			dir = Vector2.DOWN
			
	dir += $Iron_Shell.velocity.normalized() 
	dir.x *= 2
	bullet.linear_velocity = dir * projectile_speed
	screen_bullets.append(bullet)

	
