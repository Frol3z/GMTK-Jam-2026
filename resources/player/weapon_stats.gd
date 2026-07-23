class_name WeaponStats
extends Resource

@export var energyRequired: int
@export var damage: int
@export var attackRange: int
@export var cooldown: int
@export var attackType: Enums.AttackType

func _ready(p_energyRequired = 3, p_damage = 1, p_attackRange = 1, p_cooldown = 1, p_attackCountdown = 1, p_attackType = Enums.AttackType.Point) -> void:
	energyRequired = p_energyRequired
	damage = p_damage
	attackRange = p_attackRange
	cooldown = p_cooldown
	attackType = p_attackType
