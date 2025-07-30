extends Node2D

func clear_all_clones():
	for child in get_children():
		child.queue_free()
