extends Node2D

@export var current_level = 1

var sprout_amount = 0

signal sprout(current_count: int)

func load_current_level() -> void:
	var loaded: PackedScene = load("res://Levels/level_%d.tscn" % current_level) 
	if loaded == null:
		get_tree().change_scene_to_file.call_deferred("res://ending.tscn")
	else:
		add_child(loaded.instantiate())

func _ready() -> void:
	load_current_level()	

func _input(event: InputEvent) -> void:
	if OS.is_debug_build() and event.is_action_pressed("SKIP_LEVEL_CHEAT"):
		next_level()
		
	if event.is_action_pressed("sprout"):
		sprout.emit(sprout_amount)
		sprout_amount += 1
		get_node("../Player").update_sprout_counter()
		
func reset_level() -> void:
	get_node("../Clones").clear_all_clones()
	sprout_amount = 0
	get_node("../Player").update_sprout_counter()


func next_level() -> void:
	get_child(0).queue_free()
	
	get_node("../Player").position = Vector2.ZERO
	reset_level()
	
	current_level += 1
	
	load_current_level()
