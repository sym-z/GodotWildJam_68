extends Area2D

@export var door_to : String = "NULL"
@export var door_from : String = "NULL"
@export var camera : Camera2D
@export var HUD : Node2D
@export var cam_mark : Marker2D
@export var hud_mark : Marker2D

@export var to_mark : Marker2D


## Where to go back to if they are coming back through the door

func _on_entered(body):
	
	if body.name == "Iron_Shell":
		if camera.global_position != cam_mark.global_position && HUD.global_position != hud_mark.global_position:
			
			camera.global_position = cam_mark.global_position
			HUD.global_position = hud_mark.global_position
			body.global_position = to_mark.global_position
