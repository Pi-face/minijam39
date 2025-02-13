extends Node2D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

	if event.is_action_pressed("pause"):
		get_tree().paused = !get_tree().paused