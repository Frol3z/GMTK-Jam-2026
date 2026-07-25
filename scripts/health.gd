extends Node2D

enum BodyParts {
	HEAD,
	BODY,
	LEFT_ARM,
	RIGHT_ARM,
	LEFT_LEG,
	RIGHT_LEG
}

var mecha_parts : Dictionary = {}

@onready var body_collision: Area2D = $Body/BodyCollision
@onready var head_collision: Area2D = $Head/HeadCollision
@onready var right_arm_collision: Area2D = $RightArm/RightArmCollision
@onready var left_arm_collision: Area2D = $LeftArm/LeftArmCollision
@onready var right_leg_collision: Area2D = $RightLeg/RightLegCollision
@onready var left_leg_collision: Area2D = $LeftLeg/LeftLegCollision

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mecha_parts = {
		BodyParts.HEAD: { "sprite": $Head, "health": 100 },
		BodyParts.BODY: { "sprite": $Body, "health": 100 },
		BodyParts.LEFT_ARM: { "sprite": $LeftArm, "health": 100 },
		BodyParts.RIGHT_ARM: { "sprite": $RightArm, "health": 100 },
		BodyParts.LEFT_LEG: { "sprite": $LeftLeg, "health": 100 },
		BodyParts.RIGHT_LEG: { "sprite": $RightLeg, "health": 100 }
	}
	
	body_collision.input_event.connect(_on_body_part_clicked.bind(BodyParts.BODY))
	head_collision.input_event.connect(_on_body_part_clicked.bind(BodyParts.HEAD))
	right_arm_collision.input_event.connect(_on_body_part_clicked.bind(BodyParts.RIGHT_ARM))
	left_arm_collision.input_event.connect(_on_body_part_clicked.bind(BodyParts.LEFT_ARM))
	right_leg_collision.input_event.connect(_on_body_part_clicked.bind(BodyParts.RIGHT_LEG))
	left_leg_collision.input_event.connect(_on_body_part_clicked.bind(BodyParts.LEFT_LEG))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_health(BodyParts.BODY, -1)


func update_health(part: BodyParts, amount: int) -> int:
	var target_part: Dictionary = mecha_parts[part]
	
	target_part.health = clampf(target_part.health + amount, 0, 100)
	target_part.sprite.material.set_shader_parameter("amount", target_part.health)
	
	return target_part.health
	
func _on_body_part_clicked(_viewport: Node, input_event: InputEvent, _shape_idx: int, part: BodyParts) -> void:
	if input_event is InputEventMouseButton and input_event.pressed and input_event.button_index == MOUSE_BUTTON_LEFT:
		print("[DEBUG] Area2D: Body part healed - Part ID: ", part)
		update_health(part, 100)
	
