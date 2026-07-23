class_name EnemyStats
extends Resource

@export var hp: int
@export var damage: int
@export var attackRange: int
@export var moveCountdown: int
@export var attackCountdown: int
@export var attackType: Enums.AttackType

func _ready(p_hp = 3, p_damage = 1, p_attackRange = 1, p_moveCoundown = 1, p_attackCountdown = 1, p_attackType = Enums.AttackType.Point) -> void:
	hp = p_hp
	damage = p_damage
	attackRange = p_attackRange
	moveCountdown = p_moveCoundown
	attackCountdown = p_attackCountdown
	attackType = p_attackType
