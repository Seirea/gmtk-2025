extends Button

func _pressed() -> void:
	BgMusic.toggle_mute()
	$icon.frame ^= 1
