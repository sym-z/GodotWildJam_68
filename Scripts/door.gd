extends Area2D

@export var door_to : String = "NULL"
@export var door_from : String = "NULL"
@export var camera : Camera2D
@export var HUD : Node2D
@export var cam_mark : Marker2D
@export var hud_mark : Marker2D

# Where to go back to if they are coming back through the door
@export var from_cam: Marker2D
@export var from_hud: Marker2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# BUG: NEEDS TO WORK THE OTHER WAY TOO. CHECK THE POSITION WHEN THE BODY ENTERS, ONLY LET THE PLAYER ENTER
func _on_entered(body):
	if body.name == "Iron_Shell":
		if camera.position != cam_mark.position && HUD.position != hud_mark.position:
			camera.position = cam_mark.position
			HUD.position = hud_mark.position
		else:
			camera.position = from_cam.position
			HUD.position = from_hud.position
