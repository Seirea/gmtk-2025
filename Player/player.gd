class_name PlayerNode
extends CharacterBody2D

@export var speed = 128
@export var is_clone = false

var loaded = preload("res://Player/player.tscn")

func kill() -> void:
	var clone = loaded.instantiate()
	clone.get_node("CharacterBody2D").is_clone = true
	clone.position = position

	position = Vector2.ZERO
	
	get_node("/root/Main/Clones").add_child(clone)

func _input(event: InputEvent) -> void:
	if is_clone:
		return
		
	if event.is_action_pressed("reset"):
		kill()
	
	if event.is_action_pressed("hard_reset"):
		kill()
		get_node("/root/Main/Clones").clear_all_clones();
	
	
func _physics_process(delta):
	if is_clone:
		return
		
	velocity += get_gravity() * delta
	velocity.x = Input.get_axis("left", "right") * speed

	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = -256
	
	move_and_slide()
