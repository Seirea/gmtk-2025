extends Area2D

enum PlateType { AntiSprout, Activator }

@export var plate_type: PlateType = PlateType.AntiSprout
signal pressed
signal depressed

const sound = preload("res://assets/pressure-plate.wav")

var body_count = 0

func update_frame() -> void:
	$Sprite2D.frame = int(body_count > 0) + (2 if plate_type == PlateType.Activator else 0)

func _ready() -> void:
	if plate_type == PlateType.Activator:
		$Sprite2D.frame = 2


func _on_body_entered(body: Node2D) -> void:
	if body is PlayerNode:
		SoundService.play_stream(sound)
		if plate_type == PlateType.AntiSprout:
			body.flags |= PlayerNode.Flags.SproutingDisabled
			
		if body_count == 0:
			pressed.emit()
		body_count += 1
		
		print(self, "| count: ", body_count)
		update_frame()


		
func _on_body_exited(body: Node2D) -> void:
	if body is PlayerNode:
		if plate_type == PlateType.AntiSprout:
			body.flags &= ~PlayerNode.Flags.SproutingDisabled
			
		body_count -= 1
		if body_count == 0:
			depressed.emit()	
			
		print(self, "| count: ", body_count)
		update_frame()
