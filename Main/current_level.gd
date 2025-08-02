extends Node2D

@export var current_level = 1

func load_current_level() -> void:
	var loaded: PackedScene = load("res://Levels/level_%d.tscn" % current_level) 
	add_child(loaded.instantiate())

func _ready() -> void:
	load_current_level()	

func next_level() -> void:
	get_child(0).queue_free()
	get_node("../Clones").clear_all_clones()
	get_node("../Player").position = Vector2.ZERO
	current_level += 1
	
	load_current_level()
