extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 6

@onready var dashMesh = $"Dash_Ind"
@onready var usedDashMesh = $"Dash_IndUsed"
@onready var springArm = self

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
#wait timer
var dashCooldown = true
var doubleJump = true
var held = false
var dashing = false
var slamJump = false

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
	

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and slamJump:
		slamJump = false
		velocity.y = JUMP_VELOCITY*3
	elif Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_pressed("Jump") and doubleJump:
		velocity.y = JUMP_VELOCITY
		doubleJump = false
	if is_on_floor():
		doubleJump = true
	
	#rotates camera
	if Input.is_action_just_pressed("CamLeft"):
		held = true
		#print("CamLeftPressed")
		#print(springArm.get_rotation())
		var rota = Vector3(springArm.rotation_degrees)
		rota.y = rota.y + 90
		print(rota)
		springArm.set_rotation_degrees(rota)
	
	if Input.is_action_just_pressed("CamRight"):
		held = true
		#print("CamLeftPressed")
		#print(springArm.get_rotation())
		var rota = Vector3(springArm.rotation_degrees)
		rota.y = rota.y - 90
		#print(rota)
		springArm.set_rotation_degrees(rota)
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Back")
	var input_z = Input.get_axis("Slam","Jump")
	var direction = (transform.basis * Vector3(input_dir.x, input_z, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	
		if Input.is_action_just_pressed("Dash") and dashCooldown:
			dashing = true
				#velocity.x = move_toward(velocity.x,(direction.x*1000),50)
				#velocity.z = move_toward(velocity.z,(direction.z*1000),50)
			velocity.x = direction.x*100
			velocity.z = direction.z*100
			#velocity.y = move_toward(velocity.y,velocity.y*10,50)
			dashCooldown = false
			dashMesh.visible = false
			usedDashMesh.visible = true
		if Input.is_action_just_pressed("Slam") and !is_on_floor():
			velocity.y = move_toward(velocity.y,-100,50)
			slamJump = true
		if is_on_floor() and slamJump:
			slamJump = false
		if is_on_floor() and !dashCooldown:
			dashCooldown = true
			dashMesh.visible = true
			usedDashMesh.visible = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	move_and_slide()
