class_name PlayerNode
extends CharacterBody2D

enum BodyState {
	REAL,
	SPECTRE,
	SPROUT_LEFT,
	SPROUT_RIGHT
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

const left_sprout_frames: SpriteFrames = preload("res://Player/SPROUT_LEFT_FRAMES.tres")
const right_sprout_frames: SpriteFrames = preload("res://Player/SPROUT_RIGHT_FRAMES.tres")

var timeshift_sound = preload("res://assets/tick.ogg")
var loaded_player = preload("res://Player/player.tscn")
var spectre = preload("res://Player/spectre_node.tscn")

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D # Path to your Sprite2D node (if you have one, for flipping)


func _ready() -> void:	
	get_node("/root/Main/CurrentLevel").sprout.connect(ON_SPROUT)

var can_die = true

func reset_death_state():
	await get_tree().create_timer(2).timeout
	can_die = true


func kill() -> void:
	if not can_die:
		return
	can_die = false
	reset_death_state()
	
	SoundService.play_stream(timeshift_sound)
	
	self.process_mode = Node.PROCESS_MODE_DISABLED
	
	get_node("%TimeshiftModulate").visible = true
	get_node("/root/Main/CanvasLayer").show()
	await get_tree().create_timer(1.5).timeout
	get_node("%TimeshiftModulate").visible = false
	get_node("/root/Main/CanvasLayer").hide()

	self.process_mode = Node.PROCESS_MODE_INHERIT
	
	var created = spectre.instantiate()
	created.position = position
	position = Vector2.ZERO
	
	get_node("/root/Main/Clones").add_child(created)
	
func sprout() -> void:
	var clone = loaded_player.instantiate()
	
	if self.body_type == BodyState.REAL or self.body_type == BodyState.SPROUT_RIGHT:
		clone.body_type = BodyState.SPROUT_LEFT
		clone.get_node("AnimatedSprite2D").sprite_frames = left_sprout_frames
	else:
		clone.body_type = BodyState.SPROUT_RIGHT
		clone.get_node("AnimatedSprite2D").sprite_frames = right_sprout_frames
	clone.position = position - Vector2($CollisionShape2D.shape.size.x, 0)
		
	get_node("/root/Main/Clones").add_child(clone)
	
func update_sprout_counter() -> void:
	get_node("%SproutCounter").text = "Sprouts: %d/2" % min(get_node("%CurrentLevel").sprout_amount, 2)
	
func increment_sprout_count() -> void:
	get_node("%CurrentLevel").sprout_amount += 1
	get_node("%CurrentLevel").sprout_amount = min(get_node("%CurrentLevel").sprout_amount, 2)
	update_sprout_counter()


	
func _input(event: InputEvent) -> void:
	
	# sprouts and real can make new sprouts
	#if event.is_action_pressed("sprout"):
		#var sprout_amt = get_node("/root/Main/CurrentLevel").sprout_amount
		#if (sprout_amt < 2) and flags & Flags.SproutingDisabled == 0:
			#sprout()
		#elif body_type == BodyState.REAL:
			#get_node("%ErrorModulate").visible = true
			#get_node("%GlobalCamera").add_trauma(0.1)
			#await get_tree().create_timer(0.5).timeout
			#get_node("%ErrorModulate").visible = false
		#
		#if body_type == BodyState.REAL:	
			#increment_sprout_count.call_deferred()

	if body_type != BodyState.REAL:
		return
		
	# real only	
	if event.is_action_pressed("spectre"):
		kill()
	
	if event.is_action_pressed("hard_reset"):
		await kill()
		get_node("%CurrentLevel").reset_level()
	
	
func _physics_process(delta):				
	velocity += get_gravity() * delta
	velocity.x = Input.get_axis("left", "right") * speed
	
	if body_type == BodyState.SPROUT_LEFT:
		velocity.x *= -1
		
	if velocity.x != 0:
		sprite.flip_h = velocity.x < 0
	
	if is_on_floor():
		if Input.is_action_pressed("jump"):
			velocity.y = -324
			_set_animation_state("Jump")
		elif velocity.x != 0:
			_set_animation_state("Walk")
		else:
			_set_animation_state("Idle")
	
	move_and_slide()
	

func _set_animation_state(new_state: StringName) -> void:
	# Only change animation if the state is different
	if sprite.animation == new_state:
		return

	sprite.animation = new_state
	sprite.play()


func ON_SPROUT(sprout_amt: int) -> void:
	print(self,"SPROUTED")
	
	if (sprout_amt < 2) and flags & Flags.SproutingDisabled == 0:
		sprout()
	elif body_type == BodyState.REAL:
		get_node("%ErrorModulate").visible = true
		get_node("%GlobalCamera").add_trauma(0.1)
		await get_tree().create_timer(0.5).timeout
		get_node("%ErrorModulate").visible = false
	
	#if body_type == BodyState.REAL:	
		#increment_sprout_count.call_deferred()
