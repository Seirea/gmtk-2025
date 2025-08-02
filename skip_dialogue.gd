extends Button

func _pressed() -> void:
	var expo: Exposition = get_tree().current_scene
	expo.emitted[expo.indx] = true
	expo.next.emit()
