extends Control

@export var weapon_icon: Texture2D

@onready var texture_rect: TextureRect = $TextureRect
@onready var panel: Panel = $TextureRect/Panel

func _ready() -> void:
	panel.hide()
	
	texture_rect.texture = weapon_icon
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	print("Weapon entered")
	panel.show()

func _on_mouse_exited() -> void:
	print("Weapon exited")
	panel.hide()
