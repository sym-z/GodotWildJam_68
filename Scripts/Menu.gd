extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/level.tscn")
	pass # Replace with function body.



func _on_quit_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_how_to_play_pressed():
	print("hi")
	get_tree().change_scene_to_file("res://Scenes/how_to_play.tscn")
	pass # Replace with function body.




func _on_credits_pressed():
	get_tree().change_scene_to_file("res://Scenes/credits.tscn")
	pass # Replace with function body.
