# TODO: How do I change a template for a script?

# TODO: ANIMATIONS
	# Shoot
	# Hurt
	# Look Up
	# Look Down
	# Death
	# Walk Up
	# Walk Down
	# Walk Left
	# Walk Right
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

signal shoot

@export var push_force  = 1000
@export var projectile_speed = 500.0
@export var walk_speed  = 6000.0
@export var facing = dir.RIGHT;

func _ready():
	$Sprite.play()

func _physics_process(delta):
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
		# If we are moving up, don't bother flipping the sprite.
		# 1. Set the correct frame
		# 2. Set the facing variable
		if velocity.y: #Works even if it is negative
			# TODO: ADD IN CORRECT FRAME NUMBER
			$Sprite.frame = 0 if (velocity.y > 0) else 0
			facing = dir.DOWN if (velocity.y > 0) else dir.UP
		# Horizontal Movement
		elif velocity.x:
			$Sprite.flip_h = true if (velocity.x < 0) else false
			facing = dir.LEFT if (velocity.x < 0) else dir.RIGHT
		# Sanity Check
		else:
			# Shouldn't be possible because of direction check
			print("Error in movement_input() function when determining direction")
			pass
	# TODO: Idle Animation? Idle State?
	else:
		pass
		
func movement_input(delta):
	# Move the character
	if direction:
		velocity = direction * walk_speed * delta
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed)
		velocity.y = move_toward(velocity.y, 0, walk_speed)

func fire():
	emit_signal("shoot")
