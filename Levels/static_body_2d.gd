extends StaticBody2D


func _on_plate_pressed() -> void:
	self.process_mode = Node.PROCESS_MODE_DISABLED
	self.visible = false


func _on_plate_depressed() -> void:
	self.process_mode = Node.PROCESS_MODE_INHERIT
	self.visible = true
