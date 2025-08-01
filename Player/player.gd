class_name PlayerNode
extends CharacterBody2D

enum BodyState {
	REAL,
	SPECTRE,
	SPROUT_LEFT,
	SPROUT_RIGHT
}

enum AnimationState {
	IDLE,
	WALKING,
	JUMPING,
}

# BIT FLAGS
enum Flags {
	SproutingDisabled = 1,
	# AnotherFlag = 2^1
	# AnotherFlag2 = 2^2 .. etc.
}

@export var speed = 128
@export var body_type: BodyState = BodyState.REAL
@export var flags = 0


var loaded = preload("res://Player/player.tscn")

@onready var animation_player: AnimationPlayer = $AnimationPlayer # Path to your AnimationPlayer node
@onready var sprite: Sprite2D = $Sprite # Path to your Sprite2D node (if you have one, for flipping)

var current_state: AnimationState = AnimationState.IDLE

func _ready() -> void:
	_set_animation_state(AnimationState.IDLE)

func kill() -> void:
	var clone = loaded.instantiate()
	clone.body_type = BodyState.SPECTRE
	clone.position = position

	position = Vector2.ZERO
	
	get_node("/root/Main/Clones").add_child(clone)
	
func sprout() -> void:
	var clone = loaded.instantiate()
	if self.body_type == BodyState.REAL or self.body_type == BodyState.SPROUT_RIGHT:
		clone.body_type = BodyState.SPROUT_LEFT
	else:
		clone.body_type = BodyState.SPROUT_RIGHT
	clone.position = position
		
	get_node("/root/Main/Clones").add_child(clone)
	
func _input(event: InputEvent) -> void:
	if body_type == BodyState.SPECTRE:
		# spectres cannot do anything
		return
	
	# sprouts and real can make new sprouts
	if event.is_action_pressed("sprout"):
		if flags & Flags.SproutingDisabled == 0:
			sprout()

	if body_type != BodyState.REAL:
		return
		
	# real only	
	if event.is_action_pressed("spectre"):
		kill()
	
	if event.is_action_pressed("hard_reset"):
		kill()
		get_node("/root/Main/Clones").clear_all_clones();
	
	
func _physics_process(delta):
	if body_type == BodyState.SPECTRE:
		return
				
	velocity += get_gravity() * delta
	velocity.x = Input.get_axis("left", "right") * speed
	
	if body_type == BodyState.SPROUT_LEFT:
		velocity.x *= -1
		
	if velocity.x != 0:
		sprite.flip_h = velocity.x < 0
	
	if is_on_floor():
		if Input.is_action_pressed("jump"):
			velocity.y = -256
			_set_animation_state(AnimationState.JUMPING)
		elif velocity.x != 0:
			_set_animation_state(AnimationState.WALKING)
		else:
			_set_animation_state(AnimationState.IDLE)
	
	move_and_slide()

func _set_animation_state(new_state: AnimationState) -> void:
	# Only change animation if the state is different
	if current_state == new_state:
		return

	current_state = new_state
	
	match current_state:
		AnimationState.IDLE:
			animation_player.play("Idle") # Make sure you have an animation named "Idle"
		AnimationState.WALKING:
			animation_player.play("Walk") # Make sure you have an animation named "Run"
		AnimationState.JUMPING:
			animation_player.play("Jump") # Make sure you have an animation named "Jump"
