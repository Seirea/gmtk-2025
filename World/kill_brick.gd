extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is PlayerNode and body.body_type == PlayerNode.BodyState.REAL:
		body.call_deferred("kill")
