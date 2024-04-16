extends Area2D

var type : String
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_type(type : String):
	self.type = type
	match type:
		"COAL":
			$AnimatedSprite2D.animation = "coal"
		"GOLD":
			$AnimatedSprite2D.animation = "gold"
		"COPPER":
			$AnimatedSprite2D.animation = "copper"
		"IRON":
			$AnimatedSprite2D.animation = "iron"
		_:
			print("ERROR: INCORRECT VALUE IN SET_TYPE CALL");


func _on_body_entered(body):
	if body.name == "Iron_Shell":
		body.pickup(type)
		# Destroy Self
		queue_free()
	pass # Replace with function body.
