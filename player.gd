extends RigidBody2D

var base_gravity = 1.5
var down_effect = 1.35
var up_effect = 0.85

var horizonZeroSpeed = 7000
var negatSpeed = 13
var maxHorizonSpeed = 7000

var skyMove = 2000
var maxAir = Vector2(500, 1000)
var airDrag = 1

var jump = 25000
var jump_timer_max = 0.35
var jump_timer = jump_timer_max

var numJumps = 1
var isOnGround = false
signal ground(newGround);

var offset = Vector2(50, 0)

var sword: PackedScene
var swording = false
var sword_offset = 50
var sword_wait = 0.25

var sprite: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	onGround()
	sword = load("res://sword.tscn")
	sprite = $"Sprite2D"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	rotation = 0

	if isOnGround:
		groundMove()
	else:
		airMove()

	if not swording:
		fence()

	joinp(delta)

	if linear_velocity.y > 0:
		if Input.is_action_pressed("jump"):
			gravity_scale = base_gravity * up_effect
		elif Input.is_action_pressed("crouch"):
			gravity_scale = base_gravity * down_effect
		else:
			gravity_scale = base_gravity;

func onGround():
	var collision = $"Area2D"
	collision.connect("area_entered", go)
	collision.connect("area_exited", leave)

func go(area: Area2D):
	if area.is_in_group("ground"):
		numJumps = 1
		isOnGround = true
		ground.emit(isOnGround)
		jump_timer = jump_timer_max

func leave(area):
	if area.is_in_group("ground"):
		numJumps = 0
		isOnGround = false
		ground.emit(isOnGround)
	elif (area.is_in_group("death")):
		kill()

func groundMove():
	if Input.is_action_pressed("move_left"):
		apply_central_force(Vector2.LEFT * horizonZeroSpeed)
		sprite.scale.x = -0.65
	elif Input.is_action_pressed("move_right"):
		apply_central_force(Vector2.RIGHT * horizonZeroSpeed)
		sprite.scale.x = 0.65
	apply_central_force(Vector2(-linear_velocity.x * negatSpeed, 0))
		
	var dir = clamp(sign(sprite.scale.x), 0, 1)
	linear_velocity.x = clamp(linear_velocity.x, (1 - dir) * -maxHorizonSpeed, dir * maxHorizonSpeed)
	
func airMove():
	if Input.is_action_pressed("move_left") and linear_velocity.x > -maxAir.x:
		apply_central_force(Vector2.LEFT * skyMove)
	elif Input.is_action_pressed("move_right") and linear_velocity.x < maxAir.x:
		apply_central_force(Vector2.RIGHT * skyMove)
	else:
		apply_central_force(Vector2(-linear_velocity.x * airDrag, 0))

func fence():
	if Input.is_action_just_pressed("sword"):
		var new = sword.instantiate();
		add_child(new)
		new.position.x = sign(sprite.scale.x) * sword_offset
		new.scale.x = sign(sprite.scale.x)
		swording = true

		new.connect("died", no_sword)

func joinp(delta):
	if Input.is_action_pressed("jump") and jump_timer > 0:
			numJumps -= 1
			linear_velocity = Vector2(linear_velocity.x, clamp(linear_velocity.y, 0, float('inf')))
			apply_central_force(Vector2.UP * jump)
			jump_timer -= delta

func speedReset():
	maxHorizonSpeed = 500
	swording = false
	negatSpeed = 13

func no_sword():
	await get_tree().create_timer(sword_wait).timeout
	swording = false

func kill():
	pass
