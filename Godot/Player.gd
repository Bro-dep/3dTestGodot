extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 6

@onready var dashMesh = $"Dash_Ind"
@onready var usedDashMesh = $"Dash_IndUsed"
@onready var playerSelf = self
@onready var slamTimer = $"Slam Timer"
@onready var wallJumpRay = $"WallJumpRaycast"
@onready var jumpTimer = $"JumpTimer"
@onready var wallJumpTimer = $"WallJumpTimer"
@onready var moveLockTimer = $"LockMove"

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


var dashCooldown = true
var doubleJump = true
var held = false
var dashing = false
var slamJump = false
var UsedonWall = false
var canHoldJump: bool = true
var canWallJump = false
var canMove = true

var input_dir = Input.get_vector("Left", "Right", "Forward", "Back")
var input_z = Input.get_axis("Slam","Jump")

func _on_slam_timer_timeout():
	slamJump = false
	print("Slam Jump is = ",slamJump)
	
func _on_jump_timer_timeout():
	print("JumptimerOver")
	canHoldJump = false

func _on_wall_jump_timer_timeout():
	print("nomore jump")
	canWallJump = false
	
	
func _on_lock_move_timeout():
	canMove = true


func checkRayCast():
	var direction = wallJumpRay.target_position * - 1
	return direction

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if not is_on_wall():
		UsedonWall = false

	
	
	#rotates camera
	if Input.is_action_just_pressed("CamLeft"):
		held = true
		#print("CamLeftPressed")
		#print(playerSelf.get_rotation())
		var rota = Vector3(playerSelf.rotation_degrees)
		rota.y = rota.y + 90
		print(rota)
		playerSelf.set_rotation_degrees(rota)
	
	if Input.is_action_just_pressed("CamRight"):
		held = true
		#print("CamLeftPressed")
		#print(playerSelf.get_rotation())
		var rota = Vector3(playerSelf.rotation_degrees)
		rota.y = rota.y-90
		print(rota)
		playerSelf.set_rotation_degrees(rota)
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	input_dir = Input.get_vector("Left", "Right", "Forward", "Back")
	input_z = Input.get_axis("Slam","Jump")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and canMove:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		wallJumpRay.target_position = direction
	
		if Input.is_action_just_pressed("Dash") and dashCooldown:
			dashing = true
			canMove = false
				#velocity.x = move_toward(velocity.x,(direction.x*1000),50)
				#velocity.z = move_toward(velocity.z,(direction.z*1000),50)
			velocity.x = direction.x*50
			velocity.z = direction.z*50
			#velocity.y = move_toward(velocity.y,velocity.y*10,50)
			dashCooldown = false
			dashMesh.visible = false
			usedDashMesh.visible = true
			moveLockTimer.start()

			
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	
	if is_on_floor() and !dashCooldown:
		dashCooldown = true
		dashMesh.visible = true
		usedDashMesh.visible = false
	
	#Slam
	if Input.is_action_just_pressed("Slam") and !is_on_floor():
			slamJump = true
			print("Slam Jump is = ",slamJump)
			velocity.y = move_toward(velocity.y,-30,30)
			
			
	
	# Handle jump.
	#Slam jump
	if Input.is_action_just_pressed("Jump") and slamJump and is_on_floor():
		print("SlamJumped!")
		velocity.y += lerp(velocity.y,5.0,3)
		jumpTimer.start()
		slamJump = false
		
	#normal jump
	if Input.is_action_pressed("Jump") and is_on_floor() and slamTimer.is_stopped():
		print("NormalJump")
		velocity.y = JUMP_VELOCITY/2
		jumpTimer.start()
	#hold jump
	if Input.is_action_pressed("Jump") and canHoldJump and slamTimer.is_stopped():
		
		velocity.y += lerp(velocity.y,.25,.99)
	#Wall Jump
	if Input.is_action_pressed("Jump") and !UsedonWall and is_on_wall():
		#inital velocity
		canMove = false
		moveLockTimer.start()
		velocity.y = JUMP_VELOCITY
		velocity.x = checkRayCast().x*2
		velocity.z = checkRayCast().z*2
		UsedonWall = true
		canWallJump = true
		wallJumpTimer.start()
	#wall jump hold
	if Input.is_action_pressed("Jump") and canWallJump:
		#lerp based on hold
		velocity.x += lerp(velocity.x,checkRayCast().x * 5,1)
		velocity.z += lerp(velocity.z,checkRayCast().z * 5,1)
	#Double Jump
	if Input.is_action_just_pressed("Jump") and doubleJump and slamTimer.is_stopped():
		velocity.y = JUMP_VELOCITY
		doubleJump = false
	if is_on_floor():
		doubleJump = true
		canHoldJump = true
	if is_on_floor() and slamJump and slamTimer.is_stopped():
		slamTimer.start()
	
	move_and_slide()
