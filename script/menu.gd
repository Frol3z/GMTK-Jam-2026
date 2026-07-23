extends Control

const MAIN_SCENE = preload("res://main.tscn");

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(MAIN_SCENE);
