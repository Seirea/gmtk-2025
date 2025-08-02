extends Node2D

func play_stream(sample: AudioStream) -> void:
	var player = AudioStreamPlayer.new()
	player.stream = sample
	
	add_child(player)
	player.play()
	
	await player.finished
	
	player.queue_free()
