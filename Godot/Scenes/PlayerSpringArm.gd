extends SpringArm3D

@onready var target = get_parent()
# Called when the node enters the scene tree for the first time.
func _ready():
	print(target)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position = lerp(self.position,target.position,.035)
	var rotTarget = Vector3(-15,target.rotation_degrees.y,target.rotation_degrees.z)
	self.rotation_degrees = lerp(self.rotation_degrees,rotTarget,.035)
