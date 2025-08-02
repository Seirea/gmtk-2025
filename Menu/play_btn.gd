extends TextureButton

func _pressed() -> void:
	print("Switching scene")

	get_tree().change_scene_to_file("res://Main/main.tscn")
