extends Area2D

const sound = preload("res://assets/PlatformerPack/Sounds/sfx_coin.ogg")

func _on_body_entered(body: Node2D) -> void:
	print(body)
	if body is PlayerNode and body.body_type == PlayerNode.BodyState.REAL:
		SoundService.play_stream(sound)
		
		get_node("/root/Main/CurrentLevel").call_deferred("next_level")
		
		queue_free()
		
