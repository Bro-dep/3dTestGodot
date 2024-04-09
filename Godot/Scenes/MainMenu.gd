extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Level1/Level1.tscn")
func _on_d_test_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainScene.tscn")


func _on_level_1_pressed():
	get_tree().change_scene_to_file("res://Scenes/Level1/Level1.tscn")

