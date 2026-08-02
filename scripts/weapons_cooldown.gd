extends StaticBody3D

@export var sub_viewport: SubViewport
@export var mesh_instance: MeshInstance3D

func _ready() -> void:
	mouse_exited.connect(_on_mouse_exited)

func _input_event(_camera: Camera3D, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if not sub_viewport or not mesh_instance:
		return
	
	if event is InputEventMouse:
		# 1. Posizione locale rispetto alla mesh
		var local_pos: Vector3 = mesh_instance.global_transform.affine_inverse() * event_position

		# 2. Usa l'AABB della mesh
		var aabb: AABB = mesh_instance.get_aabb()
		var mesh_min := Vector2(aabb.position.x, aabb.position.y)
		var mesh_size := Vector2(aabb.size.x, aabb.size.y)

		if mesh_size.x == 0 or mesh_size.y == 0:
			return

		# 3. Mappa su coordinate UV (0.0 -> 1.0) usando i bordi della mesh
		var uv := Vector2(
			(local_pos.x - mesh_min.x) / mesh_size.x,
			1.0 - ((local_pos.y - mesh_min.y) / mesh_size.y)
		)

		# 4. Calcola posizione pixel e inoltra l'evento al SubViewport
		var viewport_size := Vector2(sub_viewport.size)
		var pixel_pos := uv * viewport_size

		var event_2d: InputEvent = event.duplicate()
		if event_2d is InputEventMouseMotion or event_2d is InputEventMouseButton:
			event_2d.position = pixel_pos
			event_2d.global_position = pixel_pos
		sub_viewport.push_input(event_2d)

func _on_mouse_exited() -> void:
	if not sub_viewport:
		return
		
	# Manda una posizione "fuori dallo schermo" per resettare l'hover della UI 2D
	var exit_event := InputEventMouseMotion.new()
	exit_event.position = Vector2(-9999, -9999)
	exit_event.global_position = Vector2(-9999, -9999)
	sub_viewport.push_input(exit_event)
