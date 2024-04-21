extends CharacterBody2D


# Where the character is facing
enum dir {LEFT = 0,RIGHT = 2,UP = 4,DOWN = 8}

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction : Vector2

var hammer_unlocked : bool = false
var shield_unlocked : bool = false

var hammering = false
var can_hammer = true

var is_shielded = false
var can_shield = true
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
			if $Sprite.animation == "up_hurt" || $Sprite.animation == "down_hurt":
				$Sprite.animation = "down_hurt" if (velocity.y > 0) else "up_hurt"
			else:
				$Sprite.animation = "walk_down" if (velocity.y > 0) else "walk_up"
			facing = dir.DOWN if (velocity.y > 0) else dir.UP
		# Horizontal Movement
		elif velocity.x:
			if $Sprite.animation == "h_hurt" :
				$Sprite.animation = "h_hurt"
			else:
				$Sprite.animation = "walk_h"
			$Sprite.flip_h = true if (velocity.x < 0) else false
			facing = dir.LEFT if (velocity.x < 0) else dir.RIGHT
		# Sanity Check
		else:
			# Shouldn't be possible because of direction check
			print("Error in movement_input() function when determining direction")
	else:
		$Sprite.pause()


		
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

	match type:
		"COAL":
			if coal_count < max_hp:
				$Pickup.play()
				coal_count += 1
		"GOLD":
			$Pickup.play()
			gold_count += 1
		"IRON":
			$Pickup.play()
			iron_count += 1
		"COPPER":
			$Pickup.play()
			copper_count += 1
		_:
			print("ERROR: IN pickup() ON MAIN_CHARACTER: TYPE NOT SET CORRECTLY")
func fire():
	if !is_shielded:
		$"Shoot Sound".play()
		emit_signal("shoot")
func hammer():
	if !is_shielded && can_hammer && !hammering:
		can_hammer = false
		hammering = true
		$Hammer.visible = true
		$Hammer/AnimatedSprite2D.play()
		$"Hammer Sound".play()
		var pals = $Hammer/Area2D.get_overlapping_bodies()
		for x in pals:
			$"RayCast2D".enabled = true
			if x.has_method("damage"):
				x.damage(null)
	else:
		$"Hurt Sound".play()
func shield():
	if can_shield && ! is_shielded:
		can_shield = false
		is_shielded = true
		$Shield.visible = true
		$Shield.play()
		$"Shield Sound".play()
	else:
		$"Hurt Sound".play()
func game_over():
	alive = false
	$"Death Sting".play()
	match $Sprite.animation:
		"down_hurt":
			$Sprite.animation = "down_death"
			$Sprite.play()
		"h_hurt":
			$Sprite.animation = "h_death"
			$Sprite.play()
		"up_hurt":
			$Sprite.animation = "up_death"
			$Sprite.play()
		"walk_down":
			$Sprite.animation = "down_death"
			$Sprite.play()
		"walk_h":
			$Sprite.animation = "h_death"
			$Sprite.play()
		"walk_up":
			$Sprite.animation = "up_death"
			$Sprite.play()
	
func take_damage():
	if !is_shielded:
		coal_count -= 1
		$"Hurt Sound".play()
		if $Sprite.animation == "walk_down":
			$Sprite.animation = "down_hurt"
			$Sprite.play()
		if $Sprite.animation == "walk_h":
			$Sprite.animation = "h_hurt"
			$Sprite.play()
		if $Sprite.animation == "walk_up":
			$Sprite.animation = "up_hurt"
			$Sprite.play()


func _on_hurt_box_entered(body):
	if !is_shielded:
		if body.has_method("enemy"):
			$DamageTick.start()
			# Initial Damage
			take_damage();

func _on_damage_tick():
	if !is_shielded:
		coal_count -= damage_over_time
		if damage_over_time != 0 && alive:
			$"Hurt Sound".play()


func _o_on_hammer_animation_finished():
	$Hammer.visible = false
	$"Hammer/AnimatedSprite2D/Cooldown Hammer".start()
	hammering = false;


func _on_sprite_animation_finished():
	match $Sprite.animation:
		"up_hurt":
			$Sprite.animation = "walk_up"
		"down_hurt":
			$Sprite.animation = "walk_down"
		"h_hurt":
			$Sprite.animation = "walk_h"
		"up_death":
			visible = false
		"h_death":
			visible = false
		"down_death":
			visible = false

func _on_death_sting_finished():
	get_tree().change_scene_to_file("res://Scenes/ending_screen.tscn")


func _on_shield_animation_finished():
	is_shielded = false
	$Shield.visible = false
	$Shield/Cooldown.start()

func _on_cooldown_timeout():
	can_shield = true


func _on_cooldown_hammer_timeout():
	can_hammer = true
