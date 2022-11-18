extends KinematicBody2D



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
export var MAX_SPEED = 80
export var ACCELERATION = 500
export var FRICTION = 500
export var ROLL_SPEED = 120

enum {
	MOVE,
	ROLL,
	ATTACK}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.LEFT
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Hello World")
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector

func _process(delta: float) -> void:
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)
		ROLL:
			roll_state(delta)

func move_state(delta:float)->void:
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector #knocksback depending on direction
		animationTree.set("parameters/Idle/blend_position",input_vector)
		animationTree.set("parameters/Run/blend_position",input_vector)
		animationTree.set("parameters/Attack/blend_position",input_vector)
		animationTree.set("parameters/Roll/blend_position",input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector*MAX_SPEED,ACCELERATION*delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO,FRICTION*delta)
	Move()
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
func roll_state(delta:float):
	velocity = roll_vector*ROLL_SPEED
	animationState.travel("Roll")
	Move()
func attack_state(delta:float):
	velocity = Vector2.ZERO
	animationState.travel("Attack")
func Move():
	velocity = move_and_slide(velocity)
func roll_animation_finished():
	velocity = velocity * 0.8
	state = MOVE
func attack_animation_finished():
	state = MOVE
