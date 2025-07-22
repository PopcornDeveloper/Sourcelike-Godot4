extends CharacterBody3D

@export var accel = 30.0
@export var friction = 15.0
@export var max_speed = 10.0
@export var speed = 5.0
@export var jump_speed = 4.5

@onready var head = $Head
@onready var camera = $Head/Camera3D

var grounded = false

var direction = Vector3.ZERO

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * 0.0025)
		head.rotate_x(-event.relative.y * 0.0025)

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta: float) -> void:
	direction = Vector3.ZERO

	velocity.y -= 16.34 * delta

	if Input.is_action_pressed("forward"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("backward"):
		direction += transform.basis.z

	if Input.is_action_pressed("left"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("right"):
		direction += transform.basis.x
	if is_on_floor():
		grounded = true
		if Input.is_action_just_pressed("jump"):
			velocity.y = 5
			velocity += direction * 1.5

		if direction != Vector3.ZERO:
			velocity.x = move_toward(velocity.x, direction.x * speed, accel * delta)
			velocity.z = move_toward(velocity.z, direction.z * speed, accel * delta)
			
			if velocity.x > 0:
				velocity.x = clampf(velocity.x, -0.01, max_speed)
			elif velocity.x < 0:
				velocity.x = clampf(velocity.x, -max_speed, 0.01)

			if velocity.z > 0:
				velocity.z = clampf(velocity.z, -0.01, max_speed)
			elif velocity.z < 0:
				velocity.z = clampf(velocity.z, -max_speed, 0.01)
		else:
			velocity.x = move_toward(velocity.x, 0, friction * delta)
			velocity.z = move_toward(velocity.z, 0, friction * delta)
	else:
		grounded = false
	
	move_and_slide()
