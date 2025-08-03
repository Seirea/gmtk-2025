extends Node2D


func _on_plate_pressed() -> void:
	$Door.set_closed(false)


func _on_plate_depressed() -> void:
	$Door.set_closed(true)
