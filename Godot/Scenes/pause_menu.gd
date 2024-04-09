extends Control

@onready var pause_Menu = $"../PauseMenu"

var paused = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pause_Menu.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func pauseMenu(): 
	if paused:
		pause_Menu.hide()
		paused = false
		Engine.time_scale = 1
	else:
		pause_Menu.show()
		paused = true
		Engine.time_scale = 0

func _on_button_resume_pressed():
	pauseMenu()
func _on_button_quit_pressed():
	get_tree().quit()
func _on_main_menu_pressed():
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
