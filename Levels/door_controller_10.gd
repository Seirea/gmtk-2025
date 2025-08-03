extends Node2D

var left_pressed = false
var right_pressed = false
var other_pressed = false

func _on_plate_depressed() -> void:
	left_pressed = false
	update()

func _on_plate_2_depressed() -> void:
	right_pressed = false
	update()

func _on_plate_pressed() -> void:
	left_pressed = true
	update()

func _on_plate_2_pressed() -> void:
	right_pressed = true
	update()

func _on_plate_3_depressed() -> void:
	other_pressed = false
	update()


func _on_plate_3_pressed() -> void:
	other_pressed = true
	update()


func update() -> void:
	$Door.set_closed(not(left_pressed and right_pressed and other_pressed))
	
