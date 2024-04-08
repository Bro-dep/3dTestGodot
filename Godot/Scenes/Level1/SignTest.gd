extends Node3D

@onready var text_sprite = $"3dText"
@onready var thingy = $Thingy


var sign1:bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	text_sprite.hide()
	thingy.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Interact") and sign1:
		print("Hello")
		thingy.hide()
		text_sprite.show()
	



func _on_area_3ds_ign_test_body_entered(body):
	sign1 = true
func _on_area_3ds_ign_test_body_exited(body):
	text_sprite.hide()
	thingy.show()
	sign1 = false
