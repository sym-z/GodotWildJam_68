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
	pass

func hurt():
	pass


func _on_area_2d_body_entered(body):
	if body.has_method("damage"):
		body.damage(self);
		print("hit");
		landed = true;
