# TODO: How do I change a template for a script?

# TODO: ANIMATIONS
	# Shoot
	# Hurt
	# Look Up
	# Look Down
	# Death
	# Metal Pickup

# TODO: USE THESE
	#tile_pos = tilemap.local_to_map(position)
	#world_pos = tilemap.map_to_local(tile_pos)
	#atlas_pos = tilemap.get_cell_atlas_coords(-1,tile_pos)
	#tile_index = atlas_pos.y * ROW_SIZE + atlas_pos.x
	#tile_obj = tile_array[tile_index]

extends CharacterBody2D


# Where the character is facing
enum dir {LEFT = 0,RIGHT = 2,UP = 4,DOWN = 8}

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction : Vector2

var hammer_unlocked : bool = false
var shield_unlocked : bool = false
signal shoot

@export var push_force  = 1000
@export var projectile_speed = 500.0
@export var walk_speed  = 6000.0
@export var facing = dir.RIGHT;
@export var health : int = 5
@export var damage_over_time : int = 0

# Weapon Upgrades
var gold_count : int = 0 
# Health Value
var coal_count : int = 5
# Defense Upgrades
var iron_count : int = 0
# Speed Upgrades
var copper_count : int = 0

# For upgrading the hp later
var max_hp : int = 5

var alive : bool = true

func _ready():
	$Sprite.play()
	

func _process(delta):
	if alive:
		var peeps = $"Hurt Box".get_overlapping_bodies()
		var peep_amt : int = 0
		for peep in peeps:
			if peep.has_method("enemy"):
				peep_amt += 1
		damage_over_time = peep_amt;
		#print(peep_amt)
		craft();
		if coal_count <= 0:
			game_over()

func _physics_process(delta):
	if alive:
		# Grab input from user
		direction = Input.get_vector("Move Left", "Move Right", "Move Up", "Move Down")
		# Move the character
		movement_input(delta)
		# Turn Sprite, change aiming direction
		look()
		# Push RigidBody2D's
		push()
		# Fire Weapon
		if Input.is_action_just_pressed("Fire"):
			fire()
		if Input.is_action_just_pressed("Use Hammer") && hammer_unlocked == true:
			hammer()
		if Input.is_action_just_pressed("Use Shield") && shield_unlocked == true:
			shield()
		# Calculate Physics
		move_and_slide()
		
func push():
	if $".".move_and_slide():
		for collisionIndex in $".".get_slide_collision_count():
			var collision = $".".get_slide_collision(collisionIndex)
			if collision.get_collider() is RigidBody2D:
				collision.get_collider().apply_force(collision.get_normal() * -push_force)

func look():
	# Determine what direction we are facing
	if direction:
		if !$Sprite.is_playing():
			$Sprite.play()
		# If we are moving up, don't bother flipping the sprite.
		# 1. Set the correct frame
		# 2. Set the facing variable
		if velocity.y: #Works even if it is negative
			# TODO: ADD IN CORRECT FRAME NUMBER
			$Sprite.animation = "walk_down" if (velocity.y > 0) else "walk_up"
			facing = dir.DOWN if (velocity.y > 0) else dir.UP
		# Horizontal Movement
		elif velocity.x:
			$Sprite.animation = "walk_h"
			$Sprite.flip_h = true if (velocity.x < 0) else false
			facing = dir.LEFT if (velocity.x < 0) else dir.RIGHT
		# Sanity Check
		else:
			# Shouldn't be possible because of direction check
			print("Error in movement_input() function when determining direction")
			pass
	# TODO: Idle Animation? Idle State?
	else:
		$Sprite.pause()
		#if facing == dir.UP || facing == dir.down:
			#
		#$Sprite.animation = "default"
		pass
		
func movement_input(delta):
	# Move the character
	if direction:
		velocity = direction * walk_speed * delta
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed)
		velocity.y = move_toward(velocity.y, 0, walk_speed)

func craft():
	if Input.is_action_just_pressed("Craft Menu"):
		if $"../Camera2D/Crafting Menu".visible == false:
			$"../Camera2D/Crafting Menu".visible = true
		else:
			$"../Camera2D/Crafting Menu".visible = false
func pickup(type):
	if type == "COAL":
		pass
	match type:
		"COAL":
			print("coal get!");
			if coal_count < max_hp:
				coal_count += 1
				print(coal_count);
				pass
		"GOLD":
			print("gold get!");
			gold_count += 1
			print(gold_count);
			pass
		"IRON":
			print("iron get!");
			iron_count += 1
			print(iron_count);
			pass
		"COPPER":
			print("copper get!");
			copper_count += 1
			print(copper_count);
			pass
		_:
			print("ERROR: IN pickup() ON MAIN_CHARACTER: TYPE NOT SET CORRECTLY")
			pass
func fire():
	emit_signal("shoot")
func hammer():
	print("using hammer!")
	$Hammer.visible = true
	$Hammer/AnimatedSprite2D.play()
	var pals = $Hammer/Area2D.get_overlapping_bodies()
	print(pals)
	for x in pals:
		if x.has_method("damage"):
			x.damage(null)
func shield():
	pass
func game_over():
	alive = false
	visible = false
	# TODO: CHANGE TO GAME OVER SCENE
	get_tree().change_scene_to_file("res://Scenes/ending_screen.tscn")
	print("Dead")
	
func take_damage():
	coal_count -= 1


func _on_hurt_box_entered(body):
	if body.has_method("enemy"):
		$DamageTick.start()
		# Initial Damage
		take_damage();
		#damage_over_time += 1
		#print(damage_over_time)
	pass # Replace with function body.


func _on_hurt_box_exited(body):
	if body.has_method("enemy"):
		# Used to turn off chain hitting
		pass # Replace with function body.


func _on_damage_tick():
	#print("Hit for ", damage_over_time, " damage");
	#print("Health is now ", coal_count)
	coal_count -= damage_over_time
	#take_damage()
	


func _o_on_hammer_animation_finished():
	$Hammer.visible = false
	pass # Replace with function body.
