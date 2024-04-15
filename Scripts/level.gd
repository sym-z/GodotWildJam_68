extends Node2D
var bullet_scene = preload("res://Scenes/projectile.tscn")
var screen_bullets = []
var projectile_speed : float = 750.0
# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _integrate_forces():
	#for bullet in screen_bullets:
		#bullet.linear_velocity = Vector2.RIGHT * projectile_speed
	pass
func _on_shoot():
	var bullet = bullet_scene.instantiate()
	var dir : Vector2
	add_child(bullet)
	bullet.position = $Iron_Shell.position
	match $Iron_Shell.facing:
		0:
			dir = Vector2.LEFT
		2:
			dir = Vector2.RIGHT
		4:
			dir = Vector2.UP
		8:
			dir = Vector2.DOWN
	bullet.linear_velocity = dir * projectile_speed
	screen_bullets.append(bullet)
