extends Node2D

func play_stream(sample: AudioStream, volume_offset: float = 0.0) -> void:
	var player = AudioStreamPlayer.new()
	player.stream = sample
	player.volume_db = volume_offset
	
	add_child(player)
	player.play()
	
	await player.finished
	
	player.queue_free()
