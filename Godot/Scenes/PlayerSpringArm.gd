extends SpringArm3D

@onready var target = get_parent()#.get_node("TargetPoint")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position = lerp(self.position,target.position,.025)
	#self.rotation = lerp(self.rotation,target.rotation,.05)
