extends AudioStreamPlayer

var muted = false

func toggle_mute():
	playing = !playing
	muted = !muted

func switch_song(song: AudioStream):
	stream = song
	if not muted:
		play()
