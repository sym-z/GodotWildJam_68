extends CharacterBody2D
@export var health : int  = 3
var bullet = preload("res://Scenes/projectile.tscn")
const SPEED = 10.0
@export var player : CharacterBody2D
# To handle state machine
enum state {PATROL, TARGET, ATTACK, HURT, DEATH}

@export var status : state
func _ready():
	status = state.PATROL
	$AnimatedSprite2D.play()

#func _process(delta):
	#follow()

func follow(delta):
	var target_position = player.position
	if(position.distance_to(target_position) < 200):
		status = state.TARGET
		if abs(target_position.y - position.y) >= abs(target_position.x - position.x):
			velocity = Vector2(0, target_position.y - position.y).normalized() * 5000 * delta
		else:
			velocity = Vector2(target_position.x - position.x, 0).normalized() * 5000 * delta
		#print( target_position.y - position.y)
		#print(" X",  target_position.x - position.x)
		#print(target_position.y)
	else:
		status = state.PATROL

func die():
	# TODO: Play death animation
	$AnimatedSprite2D.visible = false
	queue_free()

func _physics_process(delta):
	if(status != state.DEATH):
		follow(delta)
		move_and_slide()

func damage(body):
	if !body.landed:
		var bounce_dir  = Vector2(body.position - position).normalized()
		print(bounce_dir)
		velocity += bounce_dir *1000 
		move_and_slide()
		health -= 1
		status = state.DEATH if (health <= 0) else state.HURT
		$AnimatedSprite2D.animation = "hurt"
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.play()

func _on_hurtbox_entered(body):
	if body.has_method("hurt"):
		damage(body);

func _on_2d_animation_changed():
	if $AnimatedSprite2D.animation == "hurt":
		$AnimatedSprite2D/Timer.start()
		# If they just died, remove their ability to hurt char/take damage, or play death animation.



func _on_timer_timeout():
	if health <= 0:
		die()
	else:
		$AnimatedSprite2D.animation = "default"
		status = state.PATROL
		$AnimatedSprite2D.play()
