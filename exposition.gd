extends Node2D
class_name Exposition

const explosion = preload("res://assets/563010__florianreichelt__explosion.mp3")

signal next

@export var emitted = [false]

@export var indx = -1

const scary_music = preload("res://assets/515380__danlucaz__piano-loop-1.ogg")
const peace_music = preload("res://assets/679738__seth_makes_sounds__calming-piano-loop-60bpm.ogg")

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
	
	await go_next(12)
	$Text1.hide()
	$Text2.show()
	
	await go_next(12)
	$Text2.hide()
	$EvilLentil.show()
	$LentilDialogue.show()
	BgMusic.switch_song(scary_music)
	
	await go_next(12)
	$LentilDialogue.frame += 1
	
	await go_next(12)
	$LentilDialogue.frame += 1
	$Explosion.show()
	$Explosion.play("default")
	SoundService.play_stream(explosion, -15)

	await sleep(0.5)
	$Beantopia.frame = 1
	
	await go_next(3.5)
	$LentilDialogue.frame += 1
	
	
	await go_next(12)
	$EvilLentil.hide()
	$LentilDialogue.hide()
	$Text3.show()
	
	await go_next(12)
	$Text3.hide()
	$Text4.show()

	await go_next(12)
	$Text4.hide()
	$Text5.show()

	await go_next(12)
	$Text5.hide()
	$Text6.show()

	await go_next(12)
	$Text6.hide()
	$Text7.show()

	await go_next(12)
	$Text7.hide()
	BgMusic.switch_song(peace_music)

	
	get_tree().change_scene_to_file("res://Main/main.tscn")
