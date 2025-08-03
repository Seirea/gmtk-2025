extends Button

func _pressed() -> void:
	var expo = get_tree().current_scene
	expo.emitted[expo.indx] = true
	expo.next.emit()
