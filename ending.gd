extends Node2D

const explosion = preload("res://assets/563010__florianreichelt__explosion.mp3")

const diff_music = preload("res://assets/reverse_piano.ogg")

signal next

@export var emitted = [false]

@export var indx = -1

func go_next(seconds: float) -> void:
	indx += 1
	var i = indx
	emitted.append(false)
	wait(seconds, i)
	await next

func sleep(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func wait(seconds: float, i: int) -> void:
	await sleep(seconds)
	if not emitted[i]:
		next.emit()

func _ready() -> void:
	$Text1.show()
	BgMusic.switch_song(diff_music )
	
	await go_next(4)
	$Text1.hide()
	$Text2.show()
	
	await go_next(4)
	$Text2.hide()
	$EvilLentil.show()
	
	await sleep(0.5)
	$Explosion.show()
	$Explosion.play("default")
	SoundService.play_stream(explosion, -15)
	await sleep(0.5)
	$EvilLentil.hide()
	
	await go_next(1)
	$Text3.show()
	
	await go_next(3)
	$Text3.hide()
	$Beantopia.frame = 0
	
	await go_next(2)
	$Text4.show()
	
	await go_next(3)
	$Text4.hide()
	$Text5.show()
	
