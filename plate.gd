extends Area2D

enum PlateType { AntiSprout, Activator }

@export var plate_type: PlateType = PlateType.AntiSprout

signal plate_on
signal plate_off

const sound = preload("res://assets/pressure-plate.wav")

var is_pressed = false

func update_frame() -> void:
	$Sprite2D.frame = int(is_pressed) + (2 if plate_type == PlateType.Activator else 0)

func _ready() -> void:
	if plate_type == PlateType.Activator:
		$Sprite2D.frame = 2

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerNode:
		SoundService.play_stream(sound)
		is_pressed = true
		update_frame()
		if plate_type == PlateType.AntiSprout:
			body.flags |= PlayerNode.Flags.SproutingDisabled
		plate_on.emit()

func _on_body_exited(body: Node2D) -> void:
	if body is PlayerNode:
		is_pressed = false
		update_frame()
		if plate_type == PlateType.AntiSprout:
			body.flags &= ~PlayerNode.Flags.SproutingDisabled
		plate_on.emit()
