extends Area2D

const sound = preload("res://assets/pickup.ogg")
@export var is_final_star: bool = false

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerNode and body.body_type == PlayerNode.BodyState.REAL:
		SoundService.play_stream(sound)
		
		if is_final_star:
			get_tree().change_scene_to_file.call_deferred("res://ending.tscn")

			queue_free.call_deferred()
			return
		
		get_node("/root/Main/CurrentLevel").call_deferred("next_level")
		
		queue_free.call_deferred()
		
