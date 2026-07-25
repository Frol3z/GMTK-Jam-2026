class_name CabinCameraController
extends Camera3D

## Mouse look sensitivity (radians per pixel)
@export_range(0.0005, 0.01, 0.0001) var sensitivity: float = 0.002

## Vertical pitch limits in degrees (Up / Down looking angles)
@export var min_pitch_deg: float = -70.0
@export var max_pitch_deg: float = 70.0

## Horizontal yaw limits in degrees relative to starting facing direction
@export var min_yaw_deg: float = -80.0
@export var max_yaw_deg: float = 80.0

# Current rotation tracking in radians
var _pitch: float = 0.0
var _yaw: float = 0.0

# Store the initial horizontal orientation as the center reference point
var _initial_yaw: float = 0.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# Extract current starting rotations
	_pitch = rotation.x
	_yaw = rotation.y
	_initial_yaw = _yaw

func _unhandled_input(event: InputEvent) -> void:
	# Toggle mouse capture with Escape key
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return

	if event is InputEventMouseMotion:
		# Accumulate mouse motion delta
		_yaw -= event.relative.x * sensitivity
		_pitch -= event.relative.y * sensitivity
		
		# Clamp vertical pitch (looking up/down)
		var min_pitch := deg_to_rad(min_pitch_deg)
		var max_pitch := deg_to_rad(max_pitch_deg)
		_pitch = clamp(_pitch, min_pitch, max_pitch)
		
		# Clamp horizontal yaw (looking left/right around initial heading)
		var min_yaw := _initial_yaw + deg_to_rad(min_yaw_deg)
		var max_yaw := _initial_yaw + deg_to_rad(max_yaw_deg)
		_yaw = clamp(_yaw, min_yaw, max_yaw)
		
		# Apply rotation using YXZ Euler order to prevent gimbal lock
		rotation = Vector3(_pitch, _yaw, 0.0)
