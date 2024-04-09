extends Node3D

@export var Path :String



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#pause menu
	#if Input.is_action_just_pressed("Esc"):
		#get_tree().change_scene_to_file(Path)
		#print("Menu")
		#pass
	if Input.is_action_just_pressed("ui_down"):
		get_tree().reload_current_scene()


