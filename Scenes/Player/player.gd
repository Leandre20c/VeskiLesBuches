extends CharacterBody3D


@onready var cube: MeshInstance3D = $Cube

# Variables for jump buffering and coyote time
var speed: float = 10.0
var jump_force: float = 12.0  # Jump force in the Y axis
var gravity: float = 25.0

var jump_buffer_time: float = 0.2  # Time to buffer a jump input
var coyote_time: float = 0.2  # Time after leaving the ground to still jump
var jump_buffer_timer: float = 0.0  # Tracks how long the jump is buffered
var coyote_timer: float = 0.0  # Tracks how long since the player left the ground
var is_jumping: bool = false  # Tracks if the player is jumping

func _physics_process(delta: float) -> void:
	jump(delta)
	move(delta)
	
	move_and_slide()
	
func move(delta) -> void:
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	

func jump(delta) -> void:
	# Update timers
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta
	
	if is_on_floor():
		coyote_timer = coyote_time  # Reset coyote timer when on the ground
	else:
		coyote_timer -= delta
	
	# Apply gravity
	if !is_on_floor():
		velocity.y -= gravity * delta
	
	# Handle jump input buffering
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump_buffer_timer = jump_buffer_time
		velocity.y += jump_force

	# Perform the jump
	if can_jump():
		velocity.y = jump_force
		is_jumping = true
		jump_buffer_timer = 0.0
		coyote_timer = 0.0

	# Handle releasing jump early for variable height jumps
	if Input.is_action_just_released("jump") and !is_on_floor():
		velocity.y /= jump_force * 2

	# Reset is_jumping when landing
	if is_on_floor() and velocity.y == 0:
		is_jumping = false

func can_jump() -> bool:
	return (is_on_floor() or coyote_timer > 0) and jump_buffer_timer > 0
