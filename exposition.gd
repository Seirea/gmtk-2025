extends Node2D
class_name Exposition

const explosion = preload("res://assets/563010__florianreichelt__explosion.mp3")

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


func meow() -> void:
	await get_viewport()

func _ready() -> void:
	$Text1.show()
	
	await go_next(6)
	$Text1.hide()
	$Text2.show()
	
	await go_next(6)
	$Text2.hide()
	$EvilLentil.show()
	$LentilDialogue.show()
	
	await go_next(4)
	$LentilDialogue.frame += 1
	
	await go_next(4)
	$LentilDialogue.frame += 1
	$Explosion.show()
	$Explosion.play("default")
	SoundService.play_stream(explosion)

	await sleep(0.5)
	$Beantopia.frame = 1
	
	await go_next(3.5)
	$LentilDialogue.frame += 1
	
	
	await go_next(4)
	$EvilLentil.hide()
	$LentilDialogue.hide()
	$Text3.show()
	
	await go_next(6)
	$Text3.hide()
	$Text4.show()

	await go_next(6)
	$Text4.hide()
	$Text5.show()

	await go_next(6)
	$Text5.hide()
	$Text6.show()

	await go_next(6)
	$Text6.hide()
	$Text7.show()

	await go_next(6)
	$Text7.hide()
	
	get_tree().change_scene_to_file("res://Main/main.tscn")
