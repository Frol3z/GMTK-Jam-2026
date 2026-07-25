@tool
class_name Unit
extends Path2D

@export var grid: Resource = preload("res://resources/grid/grid.tres")
@export var move_range := 2
@export var skin: Texture :
	set(value):
		if value && value != skin:
			skin = value
			if not _sprite:
				await ready
			_sprite.texture = skin
			
@export var move_speed := 20.0
@onready var _sprite: Sprite2D = $PathFollow2D/Sprite2D
@onready var _anim_player: AnimationPlayer = $AnimationPlayer
@onready var _path_follow: PathFollow2D = $PathFollow2D

signal walk_finished

var grid_position := Vector2.ZERO :
	set = set_grid_position
	
var _is_walking := false :
	set = _set_is_walking

func _ready() -> void:
	# _process will be used to move unit along path
	set_process(false) 

	self.grid_position = grid.calculate_grid_coordinates(position)
	position = grid.calculate_map_position(grid_position)

	if not Engine.is_editor_hint():
		# We create the curve resource here because creating it in the editor prevents us from
		# moving the unit.
		curve = Curve2D.new()
		
	var points := [
		Vector2(2, 2),
		Vector2(2, 5),
		Vector2(8, 5),
		Vector2(8, 7),
	]
	walk_along(PackedVector2Array(points))

func set_grid_position(value: Vector2) -> void:
	grid_position = grid.clamp(value)

func take_damage() -> void:
	_anim_player.play("damaged")

func set_skin(value: Texture) -> void:
	skin = value
	if not _sprite:
		await ready
	_sprite.texture = value

func _set_is_walking(value: bool) -> void:
	_is_walking = value
	set_process(_is_walking)

func _process(delta: float) -> void:
	_path_follow.progress += move_speed * delta

	if _path_follow.progress_ratio >= 1.0:
		self._is_walking = false
		_path_follow.progress = 0.0
		position = grid.calculate_map_position(grid_position)
		curve.clear_points()
		emit_signal("walk_finished")

func walk_along(path: PackedVector2Array) -> void:
	if path.is_empty():
		return

	curve.add_point(Vector2.ZERO)
	for point in path:
		curve.add_point(grid.calculate_map_position(point) - position)
	
	grid_position = path[-1]
	# The `_is_walking` property triggers the move animation and turns on `_process()`. See
	# `_set_is_walking()` below.
	self._is_walking = true
