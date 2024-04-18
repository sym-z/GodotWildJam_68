extends RigidBody2D
var landed : bool 
signal hit
# Called when the node enters the scene tree for the first time.
func _ready():
	landed = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimatedSprite2D.flip_h = true if (linear_velocity.x <= 0) else false
	if landed:
		hurt()
	pass

func hurt():
	queue_free()
	pass






func _on_area_2d_body_entered(body):
	print(body)
	# When the bullet touches an enemy, it sends what type of projectile it is, and sets landed to be true
	if body.has_method("damage"):
		print("hit")
		body.damage(self);
		landed = true;
	elif body.has_method("wall"):
		hurt()



func _on_timer_timeout():
	# If for some reason the bullet exists for longer than 5 seconds, delete it.
	queue_free();
	pass # Replace with function body.
