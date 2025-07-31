extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is PlayerNode and not body.is_clone:
		body.call_deferred("kill")
