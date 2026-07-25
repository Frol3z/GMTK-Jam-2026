extends Control

const MAIN_SCENE = preload("res://main.tscn");

func _ready() -> void:
	_setup_button_hover_effects(self)

# Metodo ricorsivo per applicare effetti aggiuntivi in hover a tutti i bottoni della gerarchia
func _setup_button_hover_effects(node: Node) -> void:
	for child in node.get_children():
		if child is Button:
			child.mouse_entered.connect(_on_button_mouse_entered.bind(child))
			child.mouse_exited.connect(_on_button_mouse_exited.bind(child))
		
		if child.get_child_count() > 0:
			_setup_button_hover_effects(child)

func _on_button_mouse_entered(button: Button) -> void:
	if not button.text.begins_with("> "):
		button.text = "> " + button.text

func _on_button_mouse_exited(button: Button) -> void:
	if button.text.begins_with("> "):
		button.text = button.text.trim_prefix("> ")

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(MAIN_SCENE);

func _on_settings_pressed() -> void:
	pass # Replace with function body.

func _on_credits_pressed() -> void:
	pass # Replace with function body.

func _on_exit_pressed() -> void:
	get_tree().quit()
