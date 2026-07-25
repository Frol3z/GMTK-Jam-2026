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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_health(BodyParts.BODY, -1)


func update_health(part: BodyParts, amount: int) -> int:
	var target_part: Dictionary = mecha_parts[part]
	
	target_part.health = clampf(target_part.health + amount, 0, 100)
	target_part.sprite.material.set_shader_parameter("amount", target_part.health)
	
	return target_part.health
