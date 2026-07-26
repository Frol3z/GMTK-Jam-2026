extends Camera3D

## Deadzone in percentage (0.0 to 1.0). Mouse inside this radius won't rotate the camera.
@export_range(0.0, 1.0) var deadzone_radius: float = 0.05
## Maximum rotation speed (radians/sec) when mouse reaches the screen edge.
@export var max_turn_speed: float = 2.5
## How non-linear the speed curve is (higher = precise movement at the center & faster movement on the edges).
@export_range(1.0, 4.0) var response_exponent: float = 2.0
## Smoothness factor (higher = faster response, lower = smoother drift).
@export var acceleration: float = 12.0
## Maximum look-up angle in degrees.
@export_range(0.0, 89.0) var max_pitch_up: float = 80.0
## Maximum look-down angle in degrees.
@export_range(0.0, 89.0) var max_pitch_down: float = 80.0
## Maximum look-left angle in degrees from initial orientation.
@export_range(0.0, 180.0) var max_yaw_left: float = 60.0
## Maximum look-right angle in degrees from initial orientation.
@export_range(0.0, 180.0) var max_yaw_right: float = 60.0

var _current_turn_velocity: Vector2 = Vector2.ZERO
var _target_pitch: float = 0.0
var _target_yaw: float = 0.0

# Base yaw stored at startup to anchor left/right limits relative to initial rotation
var _initial_yaw: float = 0.0

func _ready() -> void:
	# Keep the mouse constrained within the window boundaries without hiding it
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	
	# Initialize target angles to current camera orientation
	_target_pitch = rotation.x
	_target_yaw = rotation.y
	_initial_yaw = rotation.y

func _process(delta: float) -> void:
	var viewport_size := get_viewport().get_visible_rect().size
	if viewport_size == Vector2.ZERO:
		return

	# Calculate normalized [-1.0, 1.0] mouse offset from center
	var mouse_pos := get_viewport().get_mouse_position()
	var center := viewport_size / 2.0
	var offset := (mouse_pos - center) / center
	
	# Clamp offset
	offset.x = clamp(offset.x, -1.0, 1.0)
	offset.y = clamp(offset.y, -1.0, 1.0)
	
	# Compute direction and magnitude from center
	var distance := offset.length()
	var target_velocity := Vector2.ZERO

	if distance > deadzone_radius:
		# Remap distance after deadzone to range [0.0, 1.0]
		var remapped_distance := (distance - deadzone_radius) / (1.0 - deadzone_radius)
		remapped_distance = clamp(remapped_distance, 0.0, 1.0)
		# Apply exponential curve
		var curved_intensity := pow(remapped_distance, response_exponent)
		# Direction vector scaled by non-linear intensity and max turn speed
		var direction := offset.normalized()
		target_velocity = direction * curved_intensity * max_turn_speed

	# Interpolate velocity for smoothness
	_current_turn_velocity = _current_turn_velocity.lerp(target_velocity, acceleration * delta)

	# Accumulate rotation
	_target_yaw -= _current_turn_velocity.x * delta
	_target_pitch -= _current_turn_velocity.y * delta

	# Clamp pitch
	var max_pitch_rad := deg_to_rad(max_pitch_up)
	var min_pitch_rad := -deg_to_rad(max_pitch_down)
	_target_pitch = clamp(_target_pitch, min_pitch_rad, max_pitch_rad)

	# Clamp yaw
	var max_yaw_rad := _initial_yaw + deg_to_rad(max_yaw_left)
	var min_yaw_rad := _initial_yaw - deg_to_rad(max_yaw_right)
	_target_yaw = clamp(_target_yaw, min_yaw_rad, max_yaw_rad)

	# Apply final rotation
	rotation = Vector3(_target_pitch, _target_yaw, 0.0)
