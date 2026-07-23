extends Control

const MAIN_SCENE = preload("res://main.tscn");

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(MAIN_SCENE);


func _on_settings_pressed() -> void:
	pass # Replace with function body.


func _on_credits_pressed() -> void:
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	get_tree().quit()
