extends RigidBody2D
var landed : bool 
signal hit
# Called when the node enters the scene tree for the first time.
func _ready():
	landed = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimatedSprite2D.flip_h = true if (linear_velocity.x <= 0) else false
	$AnimatedSprite2D.frame = 1 if (linear_velocity.y != 0) else 0
	$AnimatedSprite2D.flip_v = true if($AnimatedSprite2D.frame == 1 && linear_velocity.y > 0) else false

	if landed:
		hurt()

func hurt():
	queue_free()

func _on_area_2d_body_entered(body):
	# When the bullet touches an enemy, it sends what type of projectile it is, and sets landed to be true
	if body.has_method("damage"):
		body.damage(self);
		landed = true;
	elif body.has_method("wall"):
		hurt()

func _on_timer_timeout():
	# If for some reason the bullet exists for longer than 5 seconds, delete it.
	queue_free();
