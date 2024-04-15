extends CharacterBody2D
@export var health : int  = 3
var bullet = preload("res://Scenes/projectile.tscn")
const SPEED = 10.0

# To handle state machine
enum state {PATROL, TARGET, ATTACK, HURT, DEATH,}

func _ready():
	$AnimatedSprite2D.play()

#func _process(delta):
	#if health <= 0:
		#die()
func die():
	# TODO: Play death animation
	$AnimatedSprite2D.visible = false
	queue_free()

func _physics_process(delta):
	
	var direction = Vector2.LEFT
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()


func _on_hurtbox_entered(body):
	if body.has_method("hurt"):
		health -= 1
		$AnimatedSprite2D.animation = "hurt"
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.play()
		


func _on_2d_animation_changed():
	if $AnimatedSprite2D.animation == "hurt":
		$AnimatedSprite2D/Timer.start()
		# If they just died, remove their ability to hurt char/take damage, or play death animation.



func _on_timer_timeout():
	if health <= 0:
		die()
	else:
		$AnimatedSprite2D.animation = "default"
		$AnimatedSprite2D.play()
