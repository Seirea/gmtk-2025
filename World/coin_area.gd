extends Area2D

const sound = preload("res://assets/PlatformerPack/Sounds/sfx_coin.ogg")

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerNode and not body.is_clone:
		SoundService.play_stream(sound)
		
		get_node("/root/Main/CurrentLevel").call_deferred("next_level")
		
		queue_free()
		
