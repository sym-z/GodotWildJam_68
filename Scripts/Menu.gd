extends Control

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/level.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_how_to_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/how_to_play.tscn")

func _on_credits_pressed():
	get_tree().change_scene_to_file("res://Scenes/credits.tscn")
